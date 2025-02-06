from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)

FILE_NAME = 'students.csv'

# Перевіряємо, чи існує файл, якщо ні — створюємо
if not os.path.exists(FILE_NAME):
    with open(FILE_NAME, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['id', 'first_name', 'last_name', 'age'])  # Заголовки

# Головна сторінка 
@app.route("/")
def home():
    return "Flask API is working through Nginx!"

# Функція для читання CSV
def read_csv():
    with open(FILE_NAME, mode='r') as file:
        reader = csv.DictReader(file)
        return list(reader)


# Функція для запису до CSV
def write_csv(data):
    with open(FILE_NAME, mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(data)


# Генерація нового ID
def generate_new_id(data):
    if not data:
        return 1
    return max(int(student['id']) for student in data) + 1


# GET: Отримати студента за ID або прізвищем
@app.route('/students', methods=['GET'])
def get_students():
    data = read_csv()
    student_id = request.args.get('id')
    last_name = request.args.get('last_name')

    if student_id:
        student = next((s for s in data if s['id'] == student_id), None)
        if student:
            return jsonify(student), 200
        return jsonify({'error': 'Student not found'}), 404

    if last_name:
        students = [s for s in data if s['last_name'] == last_name]
        if students:
            return jsonify(students), 200
        return jsonify({'error': 'Students not found'}), 404

    return jsonify(data), 200


# POST: Додати нового студента
@app.route('/students', methods=['POST'])
def add_student():
    data = read_csv()
    new_student = request.json

    required_fields = {'first_name', 'last_name', 'age'}
    if not required_fields.issubset(new_student.keys()):
        return jsonify({'error': 'Missing required fields'}), 400

    new_id = generate_new_id(data)
    new_student['id'] = str(new_id)
    data.append(new_student)
    write_csv(data)

    return jsonify(new_student), 201


# PUT: Оновити дані студента за ID
@app.route('/students/<id>', methods=['PUT'])
def update_student(id):
    data = read_csv()
    student = next((s for s in data if s['id'] == id), None)

    if not student:
        return jsonify({'error': 'Student not found'}), 404

    updated_data = request.json
    required_fields = {'first_name', 'last_name', 'age'}
    if not required_fields.issubset(updated_data.keys()):
        return jsonify({'error': 'Missing required fields'}), 400

    student.update(updated_data)
    write_csv(data)

    return jsonify(student), 200


# PATCH: Оновити вік студента за ID
@app.route('/students/<id>', methods=['PATCH'])
def update_age(id):
    data = read_csv()
    student = next((s for s in data if s['id'] == id), None)

    if not student:
        return jsonify({'error': 'Student not found'}), 404

    age = request.json.get('age')
    if not age:
        return jsonify({'error': 'Missing age field'}), 400

    student['age'] = age
    write_csv(data)

    return jsonify(student), 200


# DELETE: Видалити студента за ID
@app.route('/students/<id>', methods=['DELETE'])
def delete_student(id):
    data = read_csv()
    student = next((s for s in data if s['id'] == id), None)

    if not student:
        return jsonify({'error': 'Student not found'}), 404

    data.remove(student)
    write_csv(data)

    return jsonify({'message': f'Student with ID {id} has been deleted'}), 200


if __name__ == '__main__':
    app.run(debug=True)
