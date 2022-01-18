from random import choice

mena = ("Vajco","Marek", "Žena", "Opica","Orangutan")
slovesa = ("bezi","plave", "spieva", "skace","nadava")
pridmena = ("hlupo","skaredo", "komplikovane", "silno","slabo")
predmet = ("matematiku","hry", "psa", "mobil","auto")

for _ in range (int (input("Enter integer value : "))):
    print(list(map(choice, [mena,slovesa,pridmena,predmet])))