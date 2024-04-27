import csv
import requests
from bs4 import BeautifulSoup

import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="example",
  database="TIK"
)


URL = "https://www.arbolapp.es/especies-nombre-cientifico/"
page = requests.get(URL)

soup = BeautifulSoup(page.content, "html.parser")

#resultsCientificos = list(map(lambda x:x.text.strip(),soup.find_all("h3", class_="h3 ncientifico")))
#resultsComun = list(map(lambda x:x.text.strip(),soup.find_all("h4", class_="h4")))
#resultsFotillos = list(map(lambda x:x.text.strip(),soup.find_all("h4", class_="h4")))

#results = list(map(lambda x:x.text.strip(),soup.find_all("a", class_="box-especie")))

class Tree:
    
    def __init__(self,scientificName : str, spanishName : str, image : str):
        self.scientificName = scientificName
        self.spanishName = spanishName
        self.image = image



results = soup.find_all("a", class_="box-especie")

trees = []

    
for r in results:

    img = r.find("img")["src"]
    scN = r.find("h3").text
    spN = r.find("h4").text

    mycursor = mydb.cursor()

    sql = "INSERT INTO Specie (scientificName, spanishName, imageURL) VALUES (%s, %s, %s)"
    val = (scN, spN, img)
    mycursor.execute(sql, val)

    mydb.commit()



