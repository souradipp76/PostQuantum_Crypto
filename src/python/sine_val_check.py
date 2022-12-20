from pythonds.basic.stack import Stack
import math


param_dict={}
p= [5.8229,5.0781,4.7667,0,0,0,0.2944,0.1765,0.0947,0.5080,0.2540,0.1270,0.0095,0.0016,0.0002,0.0050,0,0.0008,9.8100,10.0000,0.0010,0.0005,40.7488]

param_dict['x(1)'] = p[0];
param_dict['x(2)'] = p[1];
param_dict['x(3)'] = p[2];
param_dict['x(4)'] = p[3];
param_dict['x(5)'] = p[4];
param_dict['x(6)'] = p[5];

param_dict['m1'] = p[6];
param_dict['m2'] = p[7];
param_dict['m3'] = p[8];
param_dict['L1'] = p[9];
param_dict['L2'] = p[10];
param_dict['L3'] = p[11];
param_dict['I1'] = p[12];
param_dict['I2'] = p[13];
param_dict['I3'] = p[14];
param_dict['k1'] = p[15];
param_dict['k2'] = p[16];
param_dict['k3'] = p[17];
param_dict['g'] = p[18];

from collections import OrderedDict
trig_dict=OrderedDict()

trig_dict["2*x(1)-2*x(3)"]=2*p[0]-2*p[2]
trig_dict["2*x(1)-2*x(2)"]=2*p[0]-2*p[1]
trig_dict["x(1)-x(2)"]=p[0]-p[1]
trig_dict["x(1)+x(2)-2*x(3)"]=p[0]+p[1]-2*p[2]
trig_dict["x(1)-x(3)"]=p[0]-p[2]
trig_dict["x(1)-2*x(2)+x(3)"]=p[0]-2*p[1]+p[2]
trig_dict["x(1)"]=p[0]
trig_dict["x(1)-2*x(3)"]=p[0]-2*p[2]
trig_dict["2*x(2)-2*x(3)"]=2*p[1]-2*p[2]
trig_dict["x(1)-2*x(2)"]=p[0]-2*p[1]
trig_dict["x(2)"]=p[1]
trig_dict["x(2)-x(3)"]=p[1]-p[2]
trig_dict["2*x(1)-x(2)-x(3)"]=2*p[0]-p[1]-p[2]
trig_dict["2*x(1)-x(2)"]=2*p[0]-p[1]
trig_dict["x(2)-2*x(3)"]=p[1]-2*p[2]
trig_dict["2*x(1)+x(2)-2*x(3)"]=2*p[0]+p[1]-2*p[2]
trig_dict["x(3)"]=p[2]
trig_dict["2*x(1)-x(3)"]=2*p[0]-p[2]
trig_dict["2*x(2)-x(3)"]=2*p[1]-p[2]
trig_dict["x(1)-x(3)"]=p[0]-p[2]
trig_dict["2*x(1)-2*x(2)+x(3)"]=2*p[0]-2*p[1]+p[2]


for item in trig_dict:
    trig_dict[item]=(trig_dict[item]+2*math.pi)%(2*math.pi)
    if trig_dict[item]>math.pi:
        trig_dict[item]-=2*math.pi
    print("{} : {}".format(item,trig_dict[item]))
