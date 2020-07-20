#include <mega2560.h> 
#include <stdio.h>    
#include <stdlib.h>    
#include <math.h>
#include <delay.h>
void taskGerakan();
void inversKinematic(); 
void InputXYZ();
void mlayu();

int servoInitError[20]={
0,0,0,0,0,0,          
0,0,0,0,0,0,
0,0,0,
0,0,0,
0,0
};

eeprom int eServoInitError[20]={
-35,23,-11,-23,-45,0,      //-35,23,-11,-23,-45,0,
47,-16,25,-71,50,0,       //47,-16,25,-71,30,0,
0,0,0,
0,0,0,
0,0
};

int servo[20]={
1500,1500,1500,1500,1500,1500,
1500,1500,1500,1500,1500,1500,
1500,1500,1500,               
1500,1500,1500,
1500,1500
};         
int servoSet[20]={
1500,1500,1500,1500,1500,1500,
1500,1500,1500,1500,1500,1500,
1500,1500,1500,               
1500,1500,1500,
1500,1500
};                                            
        
int
dataInt[4]={0,0,0,0}, data[4]={0,0,0,0};
unsigned char
dataRx = 0,
countRx = 0,
countRxProtokol = 0,
dataMasuk[8]
;

// Declare your global variables here
int 
delay,
countTick,
counterTG,
counterDelay,
countGerakan,
I,
index,
langkah,
langkahMax=15,  //15
jumlahGerak,
speed,
delay_gait = 1000,
countNo
;

double
VX,VY,W,
initPositionX=0,
initPositionY=0,
initPositionZ=196,             //196 216
L1=21, 
L2=88,
L3=86,
L4=21,
X[2],Y[2],Z[2],
Xin=0,Yin=0,Zin=0,  
Xset[2],Yset[2],Zset[2],
Xlast[2],Ylast[2],Zlast[2],  
Xerror[2],Yerror[2],Zerror[2],
L1Kuadrat,L2Kuadrat,L3Kuadrat,L4Kuadrat,
XiKuadrat,YiKuadrat,ZiKuadrat,
bi,biKuadrat,ai,aiKuadrat,ci,gamai,betai,alphai[2],
A1[2],A2[2],A3[2],A4[2],A5[2],
rad,
sudutSet[20]
;
#include <lib.c>   
 
void taskGerakan()
{
    if (langkah <= 0)
    {    
        printf("===XYZ %0.2f %0.2f %0.2f || ",X[0],Y[0],Z[0]);    
        printf("===XYZ %0.2f %0.2f %0.2f \n",X[1],Y[1],Z[1]);
        
        if (VX != 0 || VY != 0 || W != 0)
        {
          countGerakan++;
        }
        else
        {
          countGerakan = 0;
        }

        if (countGerakan > jumlahGerak)
        {
          if (VX != 0 || VY != 0 || W != 0 )
            countGerakan = 1;
          else
            countGerakan = 0;
        }

        langkah = langkahMax;
        for (countNo = 0; countNo < 2; countNo++)
        {
            Xerror[countNo] = (X[countNo] - Xset[countNo]) / langkahMax;
            Yerror[countNo] = (Y[countNo] - Yset[countNo]) / langkahMax;
            Zerror[countNo] = (Z[countNo] - Zset[countNo]) / langkahMax;
        }
    }
    else
    {        
        for (countNo = 0; countNo < 2; countNo++)
        {
            Xset[countNo] += Xerror[countNo]; Yset[countNo] += Yerror[countNo]; Zset[countNo] += Zerror[countNo];
        }    
        printf("XYZset %0.2f %0.2f %0.2f || ",Xset[0],Yset[0],Zset[0]);    
        printf("XYZset %0.2f %0.2f %0.2f \n",Xset[1],Yset[1],Zset[1]);
        inversKinematic();
        for (countNo = 0; countNo < 12; countNo++)
        {
          if (servoSet[countNo] >= 2500)
            servoSet[countNo] = 2500;
          else if (servoSet[countNo] <= 500)
            servoSet[countNo] = 500;
          servo[countNo] = (int)(servoSet[countNo]);
        }  
        langkah--;  
    }
}

void inversKinematic()
{
    for(I=0;I<2;I++)
    {                        
      XiKuadrat = Xset[I] * Xset[I];
      YiKuadrat = Yset[I] * Yset[I];
      ZiKuadrat = Zset[I] * Zset[I];

      bi = sqrt(XiKuadrat + ZiKuadrat) - L1 - L4;
      biKuadrat = bi * bi;
      ai = sqrt(biKuadrat + YiKuadrat);
      aiKuadrat = ai * ai;
      gamai = atan2(Yset[I],bi);
      A1[I] = atan2(Xset[I],Zset[I]);
      A3[I] = acos((aiKuadrat - L2Kuadrat - L3Kuadrat) / (2 * L2 * L3));
      ci = L3 * cos(A3[I]);
      betai = acos((L2 + ci) / ai); 
      A2[I] = -(gamai + betai);
      alphai[I] = acos((L2Kuadrat + L3Kuadrat - biKuadrat) / (2 * L2 * L3));
      A5[I] = A1[I];  
    }    
                                       
    //kaki kanan                   
    sudutSet[5]  = 90; //pinggul
    sudutSet[4]  = (A1[0] * (rad))+90;
    sudutSet[3]  = (A2[0] * (rad));
    sudutSet[2]  = (A3[0] * (rad))+90;
    sudutSet[1]  = (-(180 - (alphai[0] * (rad)) + (sudutSet[3])))+90;
    sudutSet[0]  = (A5[0] * (rad))+90; //kaki  
    sudutSet[3]  += 70; //90      edt
                                       
    //kaki kiri
    sudutSet[11] = 90; //pinggul
    sudutSet[10] = (A1[1] * (rad))+93; //90 edit
    sudutSet[9]  = (A2[1] * (rad))+5;       //0  edit
    sudutSet[8]  = (A3[1] * (rad))+90;
    sudutSet[7]  = (-(180 - (alphai[1] * (rad)) + (sudutSet[9])))+90+3;       //90
    sudutSet[6]  = (A5[1] * (rad))+90; //kaki //90 
    sudutSet[9]  += 70;   //90             edit
    
    //printf("R %0.2f %0.2f %0.2f %0.2f %0.2f || ",sudutSet[4],sudutSet[3],sudutSet[2],sudutSet[1],sudutSet[0]); 
    //printf("L %0.2f %0.2f %0.2f %0.2f %0.2f \n",sudutSet[10],sudutSet[9],sudutSet[8],sudutSet[7],sudutSet[6]);
    for (countNo = 0; countNo < 12; countNo++)
    {
        servoSet[countNo] = 800 + (7.7777* sudutSet[countNo]);
    }                                                              
    
    //printf("SR %d %d %d %d %d || ",servoSet[4],servoSet[3],servoSet[2],servoSet[1],servoSet[0]);  
    //printf("SL %d %d %d %d %d \n ",servoSet[10],servoSet[9],servoSet[8],servoSet[7],servoSet[6]); 
    
}
void InputXYZ()
{  
    for (countNo = 0; countNo < 2; countNo++){
        X[countNo] += initPositionX; Y[countNo] += initPositionY; Z[countNo] += initPositionZ;
    }
    langkah=0;
}

void main(void)
{
init();   
X[0]=0; Y[0]=0; Z[0]=0;
X[1]=0; Y[1]=0; Z[1]=0;  
InputXYZ();
#asm("sei")
while (1)
    {       
    //langkah;  
    //mlayu();       
       switch(4)     
        {  
            case 0 :     //diam
                X[0]=0; Y[0]=0; Z[0]=0;
                X[1]=0; Y[1]=0; Z[1]=0;        
                InputXYZ();  
            break;   
            
            case 1 :      //init
                X[0]=0; Y[0]=0; Z[0]=0;
                X[1]=0; Y[1]=0; Z[1]=0;  
                InputXYZ(); 
                servoInitError[dataInt[0]]=dataInt[1];
                eServoInitError[dataInt[0]]=servoInitError[dataInt[0]];
            break;                                                     
            
            case 2 :    //variasi XYZ                
                switch(dataInt[0])     //init
                {   
                    case 1:
                       Yin=dataInt[1];
                    break;
                    case 2:
                       Xin=dataInt[1];
                    break;           
                    case 3:
                       Zin=dataInt[1];
                    break;
                }  
                X[0]=Xin; Y[0]=0; Z[0]=0;
                X[1]=Xin; Y[1]=Yin; Z[1]=Zin;  
                InputXYZ();    
            break; 
        
            case 3 :     //delay
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                        case 0:
                            Zin = 0;    
                            X[0]=0; Y[0]=0; Z[0]=Zin;
                            X[1]=0; Y[1]=0; Z[1]=Zin; 
                            InputXYZ(); 
                            langkah=0;       
                            printf("-------------------------------------------------Zin %0.f \n",Zin);
                        break;  
                        case 1:
                            Zin = -20;  
                            X[0]=0; Y[0]=0; Z[0]=Zin;
                            X[1]=0; Y[1]=0; Z[1]=Zin; 
                            InputXYZ();   
                            langkah=0;      
                            printf("-------------------------------------------------Zin %0.f \n",Zin); 
                        break;   
                    }              
                     countTick++;
                    if(countTick>1)
                        countTick=0;  
                        
                    counterDelay=500; //3000  
                }      
            break;      
            
            case 4 :     //gait
                VY=20;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                        case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     //siap
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=70; Y[0]=0; Z[0]=0;    //doyong kiwo
                            X[1]=-70; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=110; Y[0]=0; Z[0]=-60;  //angkat sikil tengen terus guwak
                            X[1]=-70; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=110; Y[0]=VY; Z[0]=-60;  //maju tengen
                            X[1]=-70; Y[1]=-VY; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=70; Y[0]=VY; Z[0]=0;     //otw siap
                            X[1]=-70; Y[1]=-VY; Z[1]=0; 
                            InputXYZ();   
                        break;    
                        case 5:  
                            X[0]=0; Y[0]=VY; Z[0]=0;      //siap
                            X[1]=0; Y[1]=-VY; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 6:  
                            X[0]=-65; Y[0]=VY; Z[0]=0;    //doyong tengen
                            X[1]=65; Y[1]=-VY; Z[1]=0; 
                            InputXYZ();     
                        break;
                        case 7:  
                            X[0]=-65; Y[0]=VY; Z[0]=0;     //angkat sikil kiwo guwak
                            X[1]=100; Y[1]=-VY; Z[1]=-55; 
                            InputXYZ();     
                        break;
                        case 8:  
                            X[0]=-65; Y[0]=-VY; Z[0]=0;      //maju kiwo
                            X[1]=100; Y[1]=VY; Z[1]=-55; 
                            InputXYZ();     
                        break;    
                        case 9:  
                            X[0]=-65; Y[0]=-VY; Z[0]=0;      //otw siap
                            X[1]=100; Y[1]=VY+VY; Z[1]=-55; 
                            InputXYZ();     
                        break;                
                        case 10:  
                            X[0]=-65; Y[0]=-VY; Z[0]=0;     // siap langsung doyong tengen
                            X[1]=65; Y[1]=VY+VY; Z[1]=0; 
                            InputXYZ();     
                        break;                
                        case 11:  
                            X[0]=0; Y[0]=-VY; Z[0]=0;
                            X[1]=0; Y[1]=VY+VY; Z[1]=0; 
                            InputXYZ();     
                        break;                
                        case 12:  
                            X[0]=65; Y[0]=-VY; Z[0]=0;
                            X[1]=-65; Y[1]=VY+VY; Z[1]=0; 
                            InputXYZ();     
                        break;            
                        case 13:  
                            X[0]=100; Y[0]=-VY; Z[0]=-55;
                            X[1]=-65; Y[1]=VY+VY; Z[1]=0; 
                            InputXYZ();     
                        break;
                        
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>13)
                            countTick=2;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=500; //3000  
                }      
            break;    
        } 
        
        speed=10; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }      
    }
}

