#!/bin/bash
  
# This creates a gif file for every package installed package
# that dpkg is aware of.

# You may need to install these packages
# sudo apt-get install apt-rdepends
# sudo apt-get install graphviz

for ii in $(  dpkg -l | awk '{print $2}' ); do
  apt-rdepends -d $ii > $ii.dotty
  dot -Gratio=auto -Tgif -o $ii-dependency.gif $ii.dotty
  rm -f $ii.dotty
done
