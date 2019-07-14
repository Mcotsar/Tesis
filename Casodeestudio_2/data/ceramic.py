import csv

#realmeans= {"belen":171.181818181818,"delicias":172.084033613445,"malpica":166.054054054054,"parlamento":163.809523809524,"villaseca":160.207547169811}
samplesize= {"belen":88,"delicias":119,"malpica":111,"parlamento":42,"villaseca":53}

realsd={"exterior_diam":11,"protruding_rim":5, "rim_w":2.5, "rim_w_2":4}
realsd=[.05,.05, .05, 0.05]
#           allmeasurments.meas={ "exterior_diam" "inside_diam"    "rim_h"    "rim_w"   "shape_w" "rim_inside_h"
#                   "belen" :{           "exterior_diam":171.1818,   95.32955,35.06818,38.32955  9.590909     27.48864},b
#                       ":delicias":        {"exterior_diam":172.0840    92.78151 34.13445 38.52101  8.747899     26.95798
#           ":malpica":         166.0541    94.75676 36.02703 37.03604  9.405405     28.92793
#           ":parlamento":      163.8095    92.57143 35.30952 34.00000 10.000000     28.73810
#           ":villaseca":       160.2075    92.71698 36.39623 35.54717 10.490566     29.75472
#                       "rim_w_"2 "protruding_rim"
#                       "belen"      31.88636       19.60227
#                       "delicias"   32.72269       14.25210
#                       "malpica"    29.80180       21.75676
#                       "parlamento" 30.07143       15.38095
#                       "villaseca"  30.79245       20.37736


def getrealdist():
    print("load workshop distiance using the file 'data/distmetrics.csv'")
    realdist={}
    with open('data/distmetrics.csv','r') as distfile:
          distances = csv.reader(distfile, delimiter=',')
          for row in distances:
              realdist[row[0]+row[1]]=float(row[2]) #print(row)
              realdist[row[1]+row[0]]=float(row[2]) #print(row)
          #worldlist[distances[1]] = {distances[2],distances[3]}
    distfile.close()
    return(realdist)
    
def getallmean():
    print("load mean for all measure for all workshop 'allmean'")
    allmeans={}
    with open('data/mean_allmeasurment.csv','r') as meanfile:
          rawmeans = csv.DictReader(meanfile, delimiter=',')
          for row in rawmeans:
              allmeans[row['']]=row
    meanfile.close()
    return(allmeans)

def getallsd():
    print("load sd for all measure for all workshop 'allsd'")
    allsds={}
    with open('data/sd_allmeasurment.csv','r') as sdfile:
          rawsds = csv.DictReader(sdfile, delimiter=',')
          for row in rawsds:
              allsds[row['']]=row
    sdfile.close()
    return(allsds)

#distances between workshops created by google maps
realdist=getrealdist() #a dictionnary storing the distance between all workshop in the form : "workshopAworkshopB"=> dist

allmeans=getallmean() #a dictionnary storing the mean
allsds=getallsd() #a dictionnary storing the sd


