import random

def guess_the_number():
    # Генеруємо випадкове число від 1 до 100
    target_number = random.randint(1, 100)
    max_attempts = 5


    print("Добрий день! Я загадав число від 1 до 100.")
    print(f"У вас є {max_attempts} спроб, щоб вгадати його.")

    for attempt in range(1, max_attempts + 1):
        try:
            # Отримуємо число від користувача
            guess = int(input(f"Спроба {attempt}: Введіть ваше припущення: "))

            if guess == target_number:
                print("Вітаємо! Ви вгадали правильне число.")
                return
            elif guess < target_number:
                print("Занадто низько. Спробуйте ще раз.")
            else:
                print("Занадто високо. Спробуйте ще раз.")
        except ValueError:
            print("Будь ласка, введіть ціле число.")

    # Якщо користувач не вгадав за 5 спроб
    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {target_number}.")
        
    input("Натисніть Enter, щоб завершити програму.")
    
if __name__ == "__main__":
    guess_the_number()
  
