zoznam = []

while True:
    volba = input("Pridaj nazov (p), ak chces vypis nazvoch (v) a ak chces spocitat (s) : ")

    if volba == "p":
        meno = input("Zadaj meno: ")
        zoznam.append(meno)
    elif volba == "v":

        for i in zoznam:
            print(i)
    elif volba == "s":
        meno = input("Zadaj meno: ")
        pocet = zoznam.count(meno)
        print("Spocitane mena:" ,pocet)
    else:
        break