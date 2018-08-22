## These two files are just for tiny modification of the figure
### trans.py [.svg] [prefix] [ratio]
The generated figures from Synchro are somehow hard to read:
- It contains transparant blocks indicating non-orthologous there, which is not the key information that we care about. 
- Also, it is usually too long in height since each block height is fixed in their program, which would be hard to read.
- The chromosome name order could be weird since it only allows for numeric naming.

So here, I just removed all the non-orthologous blocks and add a "ratio" argument for us to modify the figure a little bit.
The chromosome name are hard-coded for our case. Change them as your need.

### reorder.py [.svg]
In our case, we have special needs to reorder those chromosomes. So this is just a simple script that did that.
The order are hard-coded in the script. You have to replace them with your own order.
