my_dict = {
    "meno" : "Erik",
    "priezvisko" : "Chabron",
    "projazyk" : "ziaden",
    "adresa" : {
        "mesto" : "rakova",
        "cislodomu" : "1048",
        "ulica" : "u kajanka",

    }
}
for kluc, hodnota in list(my_dict.items()):
    print("Kluc je: ", kluc)
    print("Value je: ", hodnota)