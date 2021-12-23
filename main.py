import eel
import pyodbc
from pathlib import Path
from queue import Queue
from datetime import datetime
import time
import re

DB = 'storage'

CONNECTION = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=DESKTOP-1S21VSD\SQLEXPRESS01;' +\
             f'DATABASE={DB};UID=testuser;PWD=testuser'
TABLE = ''
PORT = 8000
DAEMON_FREQUENCY = 60

LOG_QUEUE = Queue()


@eel.expose
def html_code_for_all_tables():
    conn = pyodbc.connect(CONNECTION)
    cursor = conn.cursor()
    try:
        request = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES'
        cursor.execute(request)
        tables = cursor.fetchall()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка подключения к БД.')
        print(error)
        conn.close()
        return {'error': 'Ошибка подключения к БД.'}
    conn.close()
    code = ''
    for table in tables:
        code += f'<a class="dropdown-item" onclick="display_table(`{table[0]}`)">{table[0]}</a>'
    return {'error': None, 'code': code}


@eel.expose
def html_code_for_table(table_name, where=''):
    conn = pyodbc.connect(CONNECTION)
    cursor = conn.cursor()

    # fill column headers
    try:
        request = f'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = \'{table_name}\''
        cursor.execute(request)
        column_headers = cursor.fetchall()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка подключения к БД.')
        print(error)
        conn.close()
        return {'error': 'Ошибка подключения к БД.'}
    column_headers = [x[0] for x in column_headers]
    table_code = '<thead><tr>'
    i = 0
    for column in column_headers:
        table_code += f'<th scope="col" onclick="sortTable({i})">{column}</th>'
        i += 1
    table_code += f'<th scope="col">Удалить</th>'
    table_code += '</tr></thead>'

    # get linked tables
    request = f"SELECT QUOTENAME(PK.TABLE_NAME) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE PK " +\
              "JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C ON PK.CONSTRAINT_CATALOG=C.UNIQUE_CONSTRAINT_CATALOG"+\
              " AND PK.CONSTRAINT_SCHEMA=C.UNIQUE_CONSTRAINT_SCHEMA AND PK.CONSTRAINT_NAME=C.UNIQUE_CONSTRAINT_NAME" +\
              " JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE FK ON C.CONSTRAINT_CATALOG=PK.CONSTRAINT_CATALOG AND " +\
              "C.CONSTRAINT_SCHEMA=FK.CONSTRAINT_SCHEMA AND C.CONSTRAINT_NAME=FK.CONSTRAINT_NAME AND " +\
              f"PK.ORDINAL_POSITION=FK.ORDINAL_POSITION WHERE FK.TABLE_CATALOG='{DB}' AND FK.TABLE_NAME='{table_name}'"
    cursor.execute(request)
    linked_tables = cursor.fetchall()

    # fill column data
    try:
        request = f'SELECT * FROM {table_name} {where}'
        cursor.execute(request)
        data = cursor.fetchall()
    except BaseException as error:
        if where != '':
            LOG_QUEUE.put('Ошибка поиска.')
            print(error)
            conn.close()
            return {'error': 'Ошибка поиска.'}
        else:
            LOG_QUEUE.put('Ошибка подключения к БД.')
            print(error)
            conn.close()
            return {'error': 'Ошибка подключения к БД.'}
    conn.close()
    table_code += '<tbody>'
    for row in data:
        table_code += '<tr>'
        id = row[0]
        i = 0
        for block in row:
            if block is None:
                block = "NULL"
            changed_column = column_headers[i]
            update_query = f"{changed_column}:{column_headers[0]} = !{id}!"
            table_code += f'<td onclick="update(\'{update_query}\')">{block}</td>'
            i += 1
        table_code += f'<td><button onclick="del(\'{id}\')" type="button" class="btn btn-danger">X</button></td>'
        table_code += '</tr>'

    # add empty row for add function
    table_code += '<tr id="added_items">'
    table_code += '<td>#</td>'
    for i in range(len(column_headers) - 1):
        table_code += '<td> <input class="form-control" placeholder="NULL"> </td>'
    table_code += '</tr>'
    table_code += '</tbody>'

    # dropdown_search_button code
    dropdown = ''
    for column in column_headers:
        dropdown += f'<a class="dropdown-item" onclick="handle_search_dropdown(\'{column}\')">{column}</a>'

    # constraint_dropdown
    dropdown1 = ''
    if len(linked_tables) > 0:
        for item in linked_tables:
            dropdown1 += f'<a class="dropdown-item" onclick="new_window(\'{item[0][1:-1]}\')">{item[0][1:-1]}</a>'
    else:
        dropdown1 += f'<a class="dropdown-item">Связанных таблиц нет</a>'
    return {'code': table_code, 'dropdown': dropdown, 'headers': column_headers, 'drop': dropdown1}


@eel.expose
def add(table, columns, values):
    conn = pyodbc.connect(CONNECTION)
    cursor = conn.cursor()
    columns.pop(0)
    if 'экспедиторы' in table:
        if not validate(columns, values):
            LOG_QUEUE.put('Некорректные данные.')
            conn.close()
            return {'error': 'Некорректные данные.'}
    i = 0
    null_pointers = []
    for value in values:
        if value == '':
            null_pointers.append(i)
        i += 1
    i = 0
    for pointer in null_pointers:
        columns.pop(pointer - i)
        values.pop(pointer - i)
        i += 1
    columns = '(' + ', '.join(columns) + ')'
    values = "('" + "', '".join(values) + "')"
    try:
        request = f'insert into {table} {columns} values {values}'
        cursor.execute(request)
        cursor.commit()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка добавления данных.')
        print(error)
        conn.close()
        return {'error': 'Ошибка добавления данных.'}
    conn.close()
    return 'success'


@eel.expose
def add_several(amount, value):
    conn = pyodbc.connect(CONNECTION)
    cursor = conn.cursor()
    try:
        request = f'execute insertProducts @amount = {amount}, @box_id = {value}'
        cursor.execute(request)
        cursor.commit()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка добавления данных.')
        print(error)
        conn.close()
        return {'error': 'Ошибка добавления данных.'}
    conn.close()
    return 'success'


@eel.expose
def update(query, table_name, value):
    conn = pyodbc.connect(CONNECTION)
    if value != 'NULL':
        value = f'\'{value}\''
    cursor = conn.cursor()
    query = query.replace('!', '\'')
    changed_column, where = query.split(':')
    if ('Дата' in changed_column or 'Срок' in changed_column) and False:
        db_time = datetime.strptime(value, '%Y-%m-%d %H:%M:%S').timestamp() * 1000
        sys_time = time.time() * 1000
        if (sys_time - db_time > 30 * 24 * 60 * 60 * 1000) or ( db_time - sys_time > 0 ):
            LOG_QUEUE.put('Некорректное время.')
            conn.close()
            return {'error': 'Некорректное время.'}

    if 'экспедиторы' in table_name:
        if not validate(changed_column, value):
            LOG_QUEUE.put('Некорректные данные.')
            conn.close()
            return {'error': 'Некорректные данные.'}

    try:
        request = f"update {table_name} set {changed_column} = {value} where {where}"
        cursor.execute(request)
        cursor.commit()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка обновления данных.')
        print(error)
        conn.close()
        return {'error': 'Ошибка обновления данных.'}
    conn.close()
    return 'success'


@eel.expose
def delete(table, column, id):
    conn = pyodbc.connect(CONNECTION)
    cursor = conn.cursor()
    try:
        request = f"delete from {table} where {column} = '{id}'"
        cursor.execute(request)
        cursor.commit()
    except BaseException as error:
        LOG_QUEUE.put('Ошибка обновления данных.')
        print(error)
        conn.close()
        return {'error': 'Ошибка обновления данных.'}
    conn.close()
    return 'success'


def validate(columns, values):
    if isinstance(columns, str) and isinstance(values, str):
        columns = [columns]
        values = [values]
    for column, value in zip(columns, values):
        if column == "Фамилия" or column == "Имя" or column == "Отчество":
            if not bool(re.match(r"^\'?[A-zА-я]+\'?$", value)):
                return False
            continue
        if "Номер" in column:
            if not bool(re.match(r"^\'?[0-9+-.(.) ]+\'?$", value)):
                return False
            continue
    return True


@eel.expose
def new_window(table):
    global TABLE, PORT
    TABLE = table
    PORT += 1
    eel.init(Path(__file__).parent / 'view')
    eel.start('view2.html', port=(PORT - 1))


@eel.expose
def give_table():
    return TABLE


def expiration_daemon():
    while True:
        conn = pyodbc.connect(CONNECTION)
        cursor = conn.cursor()
        try:
            request = f"execute CheckExpired"
            cursor.execute(request)
            cursor.commit()
        except BaseException:
            pass
        conn.close()
        eel.sleep(DAEMON_FREQUENCY)


def main():
    global PORT
    PORT += 1
    eel.init(Path(__file__).parent / 'view')
    eel.spawn(expiration_daemon)
    eel.start('view.html', port=(PORT - 1))


if __name__ == '__main__':
    main()
