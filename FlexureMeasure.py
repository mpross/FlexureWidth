import Tkinter as Tk
import tkFileDialog
import numpy as np
import matplotlib.pyplot as plt

root=Tk.Tk()
f = tkFileDialog.askopenfilename()
root.withdraw()
data=np.genfromtxt(f)
x=[]
maxY=max(data[:,1])
minY=min(data[:,1])
maxX=max(data[:,0])
minX=min(data[:,0])

data = np.array([data[k] for k in xrange(len(data)) 
                       if data[k,0]<maxX/100 and data[k,0]>minX/100
                       and data[k,1]<maxY/100 and data[k,1]>minY/100])

left= np.array([data[k] for k in xrange(len(data)) 
                       if data[k,0]<0])
right= np.array([data[k] for k in xrange(len(data)) 
                       if data[k,0]>0])

print(np.mean(right[:,0])-np.mean(left[:,0]))

plt.plot(data[:,0],data[:,1],'ro')
plt.show()


