import Tkinter as Tk
import tkFileDialog
import numpy as np
import matplotlib.pyplot as plt

root=Tk.Tk()
f = tkFileDialog.askopenfilename()
root.withdraw()
data=np.genfromtxt(f)
x=[]
zoom=150
maxY=max(data[:,1])
minY=min(data[:,1])
maxX=max(data[:,0])
minX=min(data[:,0])


cut = np.array([data[k] for k in xrange(len(data)) 
                       if data[k,0]<maxX/zoom and data[k,0]>minX/zoom
                       and data[k,1]<maxY/zoom and data[k,1]>minY/zoom])

left= np.array([cut[k] for k in xrange(len(cut)) 
                       if cut[k,0]<0])
right= np.array([cut[k] for k in xrange(len(cut)) 
                       if cut[k,0]>0])

print(np.mean(right[:,0])-np.mean(left[:,0]))

plt.plot(cut[:,0],cut[:,1],'ro')
plt.axis([-0.1,0.1,-0.1,0.1])
plt.show()


