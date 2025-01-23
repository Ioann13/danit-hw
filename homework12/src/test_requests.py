import requests

BASE_URL = 'http://127.0.0.1:5000/students'


def write_results(response, step_description):
    with open('results.txt', 'a') as file:
        file.write(f"{step_description}\n")
        file.write(f"Status Code: {response.status_code}\n")
        file.write(f"Response: {response.json()}\n\n")


# Очистити файл перед записом
open('results.txt', 'w').close()

# 1. Отримати список всіх студентів
response = requests.get(BASE_URL)
write_results(response, "Step 1: Get all students")

# 2. Створити трьох студентів
students = [
    {'first_name': 'John', 'last_name': 'Doe', 'age': '20'},
    {'first_name': 'Jane', 'last_name': 'Smith', 'age': '22'},
    {'first_name': 'Alice', 'last_name': 'Brown', 'age': '19'}
]

for i, student in enumerate(students):
    response = requests.post(BASE_URL, json=student)
    write_results(response, f"Step 2.{i+1}: Add student {student}")

# 3. Отримати список всіх студентів
response = requests.get(BASE_URL)
write_results(response, "Step 3: Get all students after additions")

# 4. Оновити вік другого студента
response = requests.patch(f"{BASE_URL}/2", json={'age': '23'})
write_results(response, "Step 4: Update age of second student")

# 5. Отримати інформацію про другого студента
response = requests.get(f"{BASE_URL}?id=2")
write_results(response, "Step 5: Get second student details")

# 6. Оновити дані третього студента
response = requests.put(f"{BASE_URL}/3", json={'first_name': 'Alice', 'last_name': 'Johnson', 'age': '21'})
write_results(response, "Step 6: Update third student details")

# 7. Отримати інформацію про третього студента
response = requests.get(f"{BASE_URL}?id=3")
write_results(response, "Step 7: Get third student details")

# 8. Отримати список всіх студентів
response = requests.get(BASE_URL)
write_results(response, "Step 8: Get all students after updates")

# 9. Видалити першого студента
response = requests.delete(f"{BASE_URL}/1")
write_results(response, "Step 9: Delete first student")

# 10. Отримати список всіх студентів
response = requests.get(BASE_URL)
write_results(response, "Step 10: Get all students after deletion")
