# Клас Alphabet
class Alphabet:
    def __init__(self, lang, letters):
        """Ініціалізація алфавіту з мовою та списком літер"""
        self.lang = lang
        self.letters = list(letters)

    def print(self):
        """Друкує всі літери алфавіту"""
        print("".join(self.letters))

    def letters_num(self):
        """Повертає кількість літер в алфавіті"""
        return len(self.letters)

# Клас EngAlphabet (наслідується від Alphabet)
class EngAlphabet(Alphabet):
    _letters_num = 26  # Приватний атрибут, кількість літер в англійському алфавіті

    def __init__(self):
        """Ініціалізація англійського алфавіту"""
        super().__init__('En', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')

    def is_en_letter(self, letter):
        """Перевіряє, чи належить літера до англійського алфавіту"""
        return letter.upper() in self.letters

    def letters_num(self):
        """Повертає кількість літер в англійському алфавіті"""
        return EngAlphabet._letters_num

    @staticmethod
    def example():
        """Повертає приклад тексту англійською мовою"""
        return "Learning never exhausts the mind."

# Тести
if __name__ == "__main__":
    # Створення об'єкта EngAlphabet
    eng_alphabet = EngAlphabet()

    # Друк алфавіту
    print("Англійський алфавіт:")
    eng_alphabet.print()

    # Кількість літер в алфавіті
    print(f"\nКількість літер в англійському алфавіті: {eng_alphabet.letters_num()}")

    # Перевірка належності літери до алфавіту
    print(f"\nЧи належить літера 'F' до англійського алфавіту? {eng_alphabet.is_en_letter('F')}")
    print(f"Чи належить літера 'Щ' до англійського алфавіту? {eng_alphabet.is_en_letter('Щ')}")

    # Приклад тексту англійською
    print("\nПриклад тексту англійською мовою:")
    print(EngAlphabet.example())