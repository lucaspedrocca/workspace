#Sample Class
class PartyAnimal:
    x = 0

    name = ""
    
    def __init__(self, nam):
        self.name = nam
        print(self.name,"constructed")
    
    def party(self) :
        self.x = self.x + 1
        print(self.name,"party count",self.x)

    def __del__(self):
        print("I am destructed", self.x)


#Sample Object

s = PartyAnimal("Sally")
j = PartyAnimal("Jim")

s.party()
j.party()
s.party()



# Find Capabilities -> dir(x) donde x es un objeto que tiene adentro funciones

#Inheritance
class CricketFan(PartyAnimal):
    points = 0
    def six(self):
        self.points = self.points + 6
        self.party()
        print(self.name,"points",self.points)

s = PartyAnimal("Sally")
s.party()

j = CricketFan("Jim")
j.party()
j.six()

print(dir(j))