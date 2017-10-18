#!/scisoft/bin/python 
#called by sync.py period
#fold data according to period specified on command line
#output data all with period between 0 and 1
import numpy as np
from matplotlib import pyplot as plt
import time
#period=ARGV[0]
#print "ARGV[0] \n"
#print "Testing period of period days \n"


def getdata():
  IN1=open("dcephei.dat",'r')
  i=0
  jd=[]
  mag=[]
  obs=[]
  for line in IN1:
      if line.find('#') > -1: #skip lines with '#' in them
          continue
      t=line.split()
      jd.append(float(t[1]))
      mag.append(float(t[2]))
      obs.append((t[3]))
  IN1.close()
  jd=np.array(jd,'f')
  mag=np.array(mag,'f')
  obs=np.array(obs,'S3')
  return jd,mag,obs

def folddata(jd,period):
    phase=np.zeros(len(jd),'f')
    for i in range(len(jd)):
        diff=(jd[i]-jd[0])/period
        phase[i]=(diff - int(diff))
    return phase

def plotdata(phase,mag,period):
    plt.plot(phase,mag,'bo')
    plt.xlabel('Phase')
    plt.ylabel('Apparent Magnitude')
    title="Phase Diagram for Period = %8.4f"%(period)
    plt.title(title)

def writeoutput(phase,mag):
  OUT1=open("folded.dat",'w') 
  for i in range(len(phase)):
    OUT1.write("%5.2f %5.2f \n" % (phase[i], mag[i]))
  OUT1.close()

def phase(period):
    plt.cla()
    phase=folddata(jd,period)
    plotdata(phase,mag,period)

def phasestep(min,max,step):
    p=np.arange(min,(max+step),step)
    i=1
    for period in p:
        #plt.figure(i)
        phase(period)
        plt.draw()
        t = raw_input('type any key to continue')
        i=i+1
        time.sleep(.5)

(jd,mag,obs)=getdata()
print "To test one period, type"
print "> phase(period)"
print "where period is set to desired period"
print " "
print " "
print "To test a range of periods, type"
print "> phasestep(min,max,step)"
print "where min = starting period" 
print "and max = ending period"
print "and step is  = ending period" 
#phase=folddata(jd,period)
#plotdata(phase,mag)
#writeoutput(phase,mag)


