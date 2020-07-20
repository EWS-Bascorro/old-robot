#include <mega2560.h> 
#include <stdio.h>    
#include <stdlib.h>    
#include <math.h>
#include <delay.h>
void taskGerakan();
void inversKinematic(); 
void InputXYZ();
void maju();
void rotasi_kanan();
void rotasi_kiri();
void bangun_telentang();
void bangun_tengkurap();
void bangkit();
void siap();
void serong_kanan();
void serong_kiri();
void geser_kanan();
void geser_kiri();
void tendang(); 
void dor();
void konversi_ardu();


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
countRxProtokol = 0,
dataMasuk[8]
;


int 
robot,
delay,
tango,
tangi,
countTick,
counterTG,
counterDelay,
countGerakan,
I,
index,
langkah,
langkahMax=1,  //15
jumlahGerak,
speed,
delay_gait = 1000,
countNo
;

double
VX,VY,VZ,W,
initPositionX=0,
initPositionY=0,
initPositionZ=196,             //196 216
L1=21, 
L2=84,
L3=89,
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
// ---------------- Variabel case case an ----------------//
int state = 1;
int cariBola = 0; 
int jalan;
int de;
int ndingkluk = 0;
int kondisiAmbrukDepan,kondisiAmbrukBelakang;
int hitungNgawur = 1000;
int delayNgawur = 1000;
int hitungWaras = 1605;
int delayWaras = 1605;
int hitungTendang = 600;

// ---------------- End of variabel case -----------------//

int spx = 160,spy = 120,errorx,errory,px,py,mvx,mvy;
int sudah = 0;
void cari_bola();
void pid_servo();
void berjalan();
void pid_servo_mon();
void nek_ambruk();
void cek_ambruk();
void ngawur();

void bangun_depan();
void bangun_belakang();
#include <lib.c>   
 
void taskGerakan()
{
    if (langkah <= 0)
    {    
//        printf("===XYZ %0.2f %0.2f %0.2f || ",X[0],Y[0],Z[0]);    
//        printf("===XYZ %0.2f %0.2f %0.2f \n",X[1],Y[1],Z[1]);
        
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
//        printf("XYZset %0.2f %0.2f %0.2f || ",Xset[0],Yset[0],Zset[0]);    
//        printf("XYZset %0.2f %0.2f %0.2f \n",Xset[1],Yset[1],Zset[1]);
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
      alphai[I] = acos((L2Kuadrat + L3Kuadrat - aiKuadrat) / (2 * L2 * L3));
      A5[I] = A1[I];  
    }    
                                       
    //kaki kanan                   
    sudutSet[5]  = 90+10; //pinggul
    sudutSet[4]  = (A1[0] * (rad))+90;
    sudutSet[3]  = (A2[0] * (rad));
    sudutSet[2]  = (A3[0] * (rad))+90;
    sudutSet[1]  = (-(180 - (alphai[0] * (rad)) + (sudutSet[3])))+95;
    sudutSet[0]  = (A5[0] * (rad))+90-5+5; //kaki  
    sudutSet[3]  += 73+6-5-20; //90      edt
                                       
    //kaki kiri
    sudutSet[11] = 90; //pinggul
    sudutSet[10] = (A1[1] * (rad))+98; //90 edit
    sudutSet[9]  = (A2[1] * (rad))+5;       //0  edit
    sudutSet[8]  = (A3[1] * (rad))+90;
    sudutSet[7]  = (-(180 - (alphai[1] * (rad)) + (sudutSet[9])))+90+3;       //90
    sudutSet[6]  = (A5[1] * (rad))+90+5; //kaki //90 
    sudutSet[9]  += 69+6-5-20;   //90             edit
    
//    printf("R %0.2f %0.2f %0.2f %0.2f %0.2f || ",sudutSet[4],sudutSet[3],sudutSet[2],sudutSet[1],sudutSet[0]); 
//    printf("L %0.2f %0.2f %0.2f %0.2f %0.2f \n",sudutSet[10],sudutSet[9],sudutSet[8],sudutSet[7],sudutSet[6]);
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
hitung = 90;
robot=1;
state = 1;  
while (1)
    {    
       //maju();
       siap();    
       switch(state){
        case 0:                     
            siap();  
            konversi_raspi();
            printf("Raspi Y  %d\r\n",xx);
         break;
         
         case 1:    
            cari_bola();
         break;
         
         case 2:
            pid_servo();         
         break;    
         
         case 3:
            berjalan();         
         break;            
              

         case 10:
            bangun_depan();
         break;
         
         case 11:
            bangun_belakang();         
         break;               
         
         case 12:
            nek_ambruk();
         break;   
         
         case 13:
            cek_ambruk();         
         break;  
         
         case 101:
            ngawur();         
         break;  
        }                                                                  
         
    }
}

void pid_servo(){ //        state = 2
    nek_ambruk();    
    errorx = spx - pos_x;  
    px = errorx/47;
    mvx += px;  
    servo[19] = mvx;
    if(mvx >= 2300)mvx = 2300;
    else if (mvx <= 700)mvx = 700;     
    
//-----------------------------------------// 
    errory = spy - pos_y;  
    py = errory/47;
    mvy -= py;  
    servo[18] = mvy;
    if(mvy >= 2300)mvy = 2300;
    else if (mvy <= 1500)mvy = 1500;     
    
    printf("pid servo\r\n");
    if (Ball == 0 && pos_x <= 160) {hitungNgawur = delayNgawur; cariBola = 0; state = 1;}
    if (Ball == 0 && pos_x >= 160) {hitungNgawur = delayNgawur; cariBola = 1; state = 1;}  
    if (Ball >= 5 && pos_x >= 50 && pos_x <= 280) {jalan = 1;  state = 3;}
    if (Ball >= 5 && pos_x <= 25 ) {jalan = 0; state = 3;} 
    if (Ball >= 5 && pos_x >= 280) {jalan = 2; state = 3;}                      

}

void nek_ambruk(){
 
    if(miringDepan <= -40){ printf("Ambruk depan  %d\r\n",miringDepan); state = 13;}            // bangun tengkurap         
    else if(miringDepan >= 40){ printf("Ambruk belakang  %d\r\n",miringDepan); state = 13;}   // bangun terlentang
    
}

void cek_ambruk(){
 
    if(miringDepan <= -40 ){sudah = 0; printf("cek Ambruk depan %d\r\n",miringDepan); TIMSK1=0x07; state = 10;}         // bangun tengkurap   
    if(miringDepan >= 40){ sudah = 0; printf("cek Ambruk belakang %d\r\n",miringDepan); TIMSK1=0x07; state = 11;}   // bangun terlentang            
}

void bangun_depan(){
    durung:

        printf("proses bangun depan %d\r\n",miringDepan);
        bangun_tengkurap();            
        if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukDepan = 1; goto wes;}    
        if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40 )) {kondisiAmbrukDepan = 0; goto wes;}
    goto durung;
    
    wes:
        printf("wes\r\n"); 
        tango = 0;
        if(kondisiAmbrukDepan == 1){hitungNgawur = delayNgawur; state = 1;}
        else {sudah = 0; state = 12;}                                         
}

void bangun_belakang(){
    durung:

        printf("proses bangun belakang %d\r\n",miringDepan);
        bangun_telentang();
        if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukBelakang = 1; goto wes;}            
        if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40)) {kondisiAmbrukBelakang = 0; goto wes;}
    goto durung;
    
    wes:
        printf("Wes cok\r\n");  
        tangi = 0;
        if(kondisiAmbrukBelakang == 1){hitungNgawur = delayNgawur; state = 1;}
        else {sudah = 0; state = 12;}
                                                                       
        
}

void berjalan(){    //state = 3
    switch(jalan){
     case 0:  //diam     
        nek_ambruk();
        serong_kiri();     
        pid_servo();   
        if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] <= 1700) {jalan = 1; servo[19] = 1500;} // nek wes neng ngarep 
        if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;} // nek ra ndetek neng cari bola   
        printf("%d serong kiri bos\r\n",servo[18]);
     break;
     
     case 1:   //maju
        nek_ambruk();     
        maju();                                  
        pid_servo_mon();      
        if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}        
        if(servo[19] >= 1800){jalan = 0;}   
        if(servo[19] <= 1200){jalan = 2;} 
        printf("%d maju jalan\r\n",servo[18]);
     break;
     
     case 2:    //rotasi kanan
        nek_ambruk();      
        rotasi_kanan(); 
        pid_servo();                    
        if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}       
        if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}   
        printf("%d serong kanan\r\n",servo[18]);   
     break;    
     
     case 3:   //rotasi kiri
        nek_ambruk();      
        rotasi_kiri(); 
        pid_servo();                    
        if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}       
        if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}   
        printf("%d serong kanan\r\n",servo[18]);   
     break;
     
     
     
    }

}

void cari_bola(){//         state = 1
    switch(cariBola){
    case 0:                                    
        nek_ambruk();
        if(servo[18] >= 1800) servo[18] = 1500;                 
        printf("cari bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);            
        servo[19]+=1;
        if(servo[19] >= 2300) cariBola = 1; 
        if(Ball >= 5 ) {mvx = servo[19]; mvy = servo[18]; state = 2;}  
        if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}     
        
                  
     break;
             
     case 1:
        nek_ambruk();      
        if(servo[18] < 1800) servo[18] = 1800;
        printf("cari bola %d %d == %d\r\n",miringDepan, servo[19], hitungNgawur); 
        servo[19]-=1;
        if(servo[19] <= 700)cariBola = 0;
        if(Ball >= 5 ) {mvx = servo[19]; mvy = servo[18]; state = 2;}
        if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}     
        
                     
     break;
    }
    siap(); 
    
}

void ngitung(){
    hitung = 600;
    jalan = 1;
    state = 3;
}

void ngawur(){
    nek_ambruk();  
    maju();           
    servo[18] = 1500;
    servo[19] = 1500;
    if(hitungWaras <= 0) {hitungNgawur = delayNgawur; state = 1;} 
    if(Ball >= 5){mvx = servo[19]; mvy = servo[18]; state = 2;}
    printf("Aku Ngawur %d - %d\r\n",miringDepan, hitungWaras);
}

void pid_servo_mon(){ //    

    errorx = spx - pos_x;  
    px = errorx/47;
    mvx += px;  
    servo[19] = mvx;
    if(mvx >= 2300)mvx = 2300;
    else if (mvx <= 700)mvx = 700;    
    
    errory = spy - pos_y;  
    py = errory/47;
    mvy -= py;  
    servo[18] = mvy;
    if(mvy <= 1000)mvy = 1000;
    else if (mvy >= 2300)mvy = 2300;   

}

void siap()
  {  
   
   //tangan kanan
    servo[14] = 1350; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1650; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju   
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:
                       servoInitError[7]=40;   
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>0)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=75; //3000  
                }     
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
  }


void goal()
 {
      de = 100;
      switch(tangi)
      {
       case 0:
            servo[14] = 1800; //R3 - CW
            servo[13] = 900; //R2 - turun
            servo[12] = 1900; //R1 - mundur  
            //tangan kiri
            servo[17]  = 1200; //L3 - CW   
            servo[16]  = 2050; //L2 - naik
            servo[15]  = 1100; //L1 - maju   
            //kaki kanan
            servo[5] = 800 + (7.7777* 90); //pinggul ra enek
            servo[4] = 1520; //R5 - kiri
            servo[3] = 1136; //R4 - maju
            servo[2] = 1931; //R3 - maju
            servo[1] = 1289; //R2 - maju
            servo[0] = 1500; //R1 - kiri                                     
            //kaki kiri
            servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
            servo[10] = 1500; //L5 - kanan
            servo[9]  = 1136; //L4 - maju    984
            servo[8]  = 1931; //L3 - maju
            servo[7]  = 1289; //L2 - maju
            servo[6]  = 1500; //L1 - kanan 
            tangi=1;          
            delay_ms(3000);
       break;  
       
       case 1:
            servo[14] = 1800; //R3 - CW
            servo[13] = 900; //R2 - turun
            servo[12] = 1900; //R1 - mundur  
            //tangan kiri
            servo[17]  = 1200; //L3 - CW   
            servo[16]  = 2050; //L2 - naik
            servo[15]  = 1100; //L1 - maju   
            //kaki kanan
            servo[5] = 800 + (7.7777* 90); //pinggul ra enek
            servo[4] = 1587; //R5 - kiri
            servo[3] = 1136; //R4 - maju
            servo[2] = 1931; //R3 - maju
            servo[1] = 1289; //R2 - maju
            servo[0] = 1567; //R1 - kiri                                     
            //kaki kiri
            servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
            servo[10] = 1453; //L5 - kanan
            servo[9]  = 1136; //L4 - maju    984
            servo[8]  = 1931; //L3 - maju
            servo[7]  = 1289; //L2 - maju
            servo[6]  = 1453; //L1 - kanan 
            tangi=2;          
            delay_ms(de);
       break;   
       
       case 2:
            //tangan kanan
            servo[14] = 1800; //R3 - CW
            servo[13] = 900; //R2 - turun
            servo[12] = 1900; //R1 - mundur  
            //tangan kiri
            servo[17]  = 1200; //L3 - CW   
            servo[16]  = 1500; //L2 - naik
            servo[15]  = 1100; //L1 - maju      
            //kaki kanan
            servo[5] = 800 + (7.7777* 90); //pinggul ra enek
            servo[4] = 1587; //R5 - kiri
            servo[3] = 1138; //R4 - maju
            servo[2] = 1842; //R3 - maju
            servo[1] = 1219; //R2 - maju
            servo[0] = 1567; //R1 - kiri                                     
            //kaki kiri
            servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
            servo[10] = 1453; //L5 - kanan
            servo[9]  = 1381; //L4 - maju    984
            servo[8]  = 1802; //L3 - maju
            servo[7]  = 1212; //L2 - maju
            servo[6]  = 1453; //L1 - kanan 
            tangi=2;          
            delay_ms(de);
       break;
      }
 }

void dor(){
    langkahMax=1;
    //tangan kanan
    servo[14] = 1800; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1200; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                       langkahMax=1;
                            X[0]=-90; Y[0]=0; Z[0]=-20;  
                            X[1]=70; Y[1]=-40; Z[1]=-50; 
                            InputXYZ();       
                        break;  
                        case 1:     
                        langkahMax=1;
                            X[0]=-90; Y[0]=0; Z[0]=-20;  
                            X[1]=70; Y[1]=40; Z[1]=-50; 
                            InputXYZ();   
                        break; 
                        case 2:      
                        langkahMax=1;
                            X[0]=0; Y[0]=0; Z[0]=-20;  
                            X[1]=0; Y[1]=0; Z[1]=-20; 
                            InputXYZ();      
                        break;  
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>2)
                           countTick=2;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=120; //65 80 
                } 
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void tendang(){
    langkahMax=40;
    //tangan kanan
    servo[14] = 1800; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1300; //L3 - CW   
    servo[16]  = 2100; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=45;   //40 42       
                VZ=30;   //25
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:               
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
//                        case 1:  
//                        servoInitError[6]=250;
//                            X[0]=-VY; Y[0]=0; Z[0]=0;    
//                            X[1]=VY; Y[1]=0; Z[1]=-VZ; 
//                            InputXYZ();   
//                        break; 
                        case 1:                     
                        servoInitError[6]=300;      //250
                        servoInitError[14]=-600; 
                        servoInitError[13]=600;
                        //servoInitError[17]=600; 
                            X[0]=-VY-5; Y[0]=0; Z[0]=0;  
                            X[1]=VY; Y[1]=0; Z[1]=-VZ; 
                            InputXYZ();      
                        break;  
                        case 2:              
                        servoInitError[6]=300;
                        servoInitError[9]=-250;  
                        servoInitError[8]=-250;
                        servoInitError[7]=500;
                            X[0]=-VY-5; Y[0]=0; Z[0]=0;  
                            X[1]=VY; Y[1]=0; Z[1]=-VZ-20; 
                            InputXYZ();     
                        break;  
                        case 3:           
                        servoInitError[6]=0;
                        servoInitError[9]=0;  
                        servoInitError[8]=0;
                        servoInitError[7]=0; 
                        servoInitError[14]=0;
                        servoInitError[13]=0;
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ(); 
                        break; 
                        case 5:     
                        langkahMax=1;
                            X[0]=0; Y[0]=0; Z[0]=-20;  
                            X[1]=0; Y[1]=0; Z[1]=-20; 
                            InputXYZ();      
                        break; 
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>3)
                           countTick=3;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=500; //500
                }   
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void geser_kiri(){
    //tangan kanan
    servo[14] = 1800; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1200; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=-10; Y[0]=0; Z[0]=0;    
                            X[1]=10; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=-10; Y[0]=0; Z[0]=0;  
                            X[1]=15; Y[1]=0; Z[1]=-40; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=15; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=0; Y[0]=0; Z[0]=0; 
                            X[1]=-15; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=0; Y[0]=-0; Z[0]=-40;   
                            X[1]=-15; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=0; Y[0]=0; Z[0]=0;      
                            X[1]=-15; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>6)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=80; //65 80 
                }     
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void geser_kanan(){
    //tangan kanan
    servo[14] = 1600; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1400; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=10; Y[0]=0; Z[0]=0;    
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=15; Y[0]=-20; Z[0]=-30;  
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=15; Y[0]=-20; Z[0]=0;  
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=-15; Y[0]=-20; Z[0]=0; 
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=-15; Y[0]=-20; Z[0]=0;   
                            X[1]=0; Y[1]=-15; Z[1]=-30; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=-15; Y[0]=-20; Z[0]=0;      
                            X[1]=0; Y[1]=-15; Z[1]=0; 
                            InputXYZ();      
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>6)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=80; //65 80 
                }   
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void serong_kiri(){
    //tangan kanan
    servo[14] = 1500; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1500; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=-10; Y[0]=0; Z[0]=0;    
                            X[1]=10; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=-10; Y[0]=0; Z[0]=0;  
                            X[1]=15; Y[1]=-10; Z[1]=-40; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=15; Y[1]=-10; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=0; Y[0]=0; Z[0]=0; 
                            X[1]=-15; Y[1]=-10; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=0; Y[0]=20; Z[0]=-40;   
                            X[1]=-15; Y[1]=-10; Z[1]=0; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=0; Y[0]=20; Z[0]=0;      
                            X[1]=-15; Y[1]=-10; Z[1]=0; 
                            InputXYZ();      
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>6)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=85; //65 80 
                }     
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void serong_kanan(){
    //tangan kanan
    servo[14] = 1600; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1500; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=15;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=10; Y[0]=0; Z[0]=0;    
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=10; Y[0]=-10; Z[0]=-40;  
                            X[1]=-15; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=15; Y[0]=-10; Z[0]=0;  
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=-15; Y[0]=-10; Z[0]=0; 
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=-15; Y[0]=-10; Z[0]=0;   
                            X[1]=0; Y[1]=20; Z[1]=-40; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=-15; Y[0]=-10; Z[0]=0;      
                            X[1]=0; Y[1]=20; Z[1]=0; 
                            InputXYZ();      
                        break;
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>6)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=80; //65 80 
                }    
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void bangun_telentang()
    {  
     int de  = 1000;        
     int lay = 50;         
     //tangi = 8;
          switch(tangi)
          {  
               
           case 0:                  
                    //ndas
                    servo[18]  = 500; //L1 - maju
                    servo[19]  = 2000; //L2 - naik
                    //kaki kanan
                    servo[5] = 1500; 
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 1500; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 1500; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 1500; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 1500; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(3000);     
                    
                    tangi=0;
           break; 
          
           case 1:   
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 1500; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 1500; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 800; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 2100; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(de);     
                     
                    tangi=2;
           break; 
             
           
           case 2:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 800; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 2100; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 800; //R2 - turun
                    servo[12] = 1000; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 2100; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(de);    
                     
                    tangi=3;
           break;          
           
           case 3:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 1500; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 1500; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 800; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 2100; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(de);    
                     
                    tangi=4;
           break;     
           
           case 4:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 1500; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 1500; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 1500; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 1500; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(de);  
                     
                    tangi=5;
           break; 
          
           case 5:   
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 1500; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 1500; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(lay);   
                     
                    tangi=6;
           break; 
             
           
           case 6:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);  
                     
                    tangi=7;
           break;          
           
           case 7:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);    
                     
                    tangi=8;
           break;     
           
           case 8:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1460; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 470;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 460; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1600; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 850; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);   
                     
                    tangi=9;
           break; 
           
           case 9:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 480;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1460; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2150; //R2 - turun
                    servo[12] = 1700; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 800; //L2 - naik
                    servo[15]  = 1400; //L1 - maju
                    delay_ms(de);       
                     
                    tangi=10;
           break;         
           
           case 10:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1306; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1306; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);
                     
                    tangi=11;
           break; 
           
           case 11:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1306; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1306; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1600; //R3 - CW
                    servo[13] = 1000; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1400; //L3 - CW   
                    servo[16]  = 2000; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);  
                     
                    tangi=12;
           break;
           
           case 12:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 800;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1056; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 800;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1056; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1200; //R3 - CW
                    servo[13] = 1000; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1800; //L3 - CW   
                    servo[16]  = 2000; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);          
                     
                    countTick=0;
                    tangi=13;
           break;   
           
           case 13:       
                    bangkit();  
           break;
          }   
    }

void bangun_tengkurap()
   {          
    int de  = 1000;        
    int lay = 50; 
    //tango = 6;   
          switch(tango)
          {  
           case 0:       
                     //ndas
                    servo[18]  = 500; //L1 - maju
                    servo[19]  = 2000; //L2 - naik
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 1500; //R4 - maju
                    servo[2] = 1500; //R3 - maju
                    servo[1] = 1500; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 1500; //L4 - maju    984
                    servo[8]  = 1500; //L3 - maju
                    servo[7]  = 1500; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan 
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 1500; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 1500; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(de);   
                     
                    tango=0;
           break; 
          
           case 1:   
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 1500; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[15]  = 1500; //L1 - maju
                    servo[16]  = 1500; //L2 - naik
                    servo[17]  = 1500; //L3 - CW  
                    delay_ms(lay);           
                     
                    tango=2;
           break; 
             
           
           case 2:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);         
                     
                    tango=3;
           break;          
           
           case 3:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 984;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 984;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1500; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);           
                     
                    tango=4;
           break;     
           
           case 4:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1460; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 470;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 460; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1600; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 850; //L2 - naik
                    servo[15]  = 1500; //L1 - maju
                    delay_ms(lay);         
                     
                    tango=5;
           break; 
           
           case 5:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 480;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1006; //R2 - maju
                    servo[0] = 1460; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1006; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2150; //R2 - turun
                    servo[12] = 1700; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 800; //L2 - naik
                    servo[15]  = 1400; //L1 - maju
                    delay_ms(de);       
                     
                    tango=6;
           break;         
           
           case 6:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1306; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1306; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 500; //R3 - CW
                    servo[13] = 2100; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 2500; //L3 - CW   
                    servo[16]  = 900; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);         
                     
                    tango=7;
           break; 
           
           case 7:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 500;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1306; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 500;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1306; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1600; //R3 - CW
                    servo[13] = 1000; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1400; //L3 - CW   
                    servo[16]  = 2000; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);        
                     
                    tango=8;
           break;
           
           case 8:  
                    //kaki kanan
                    servo[5] = 1500;
                    servo[4] = 1500; //R5 - kiri
                    servo[3] = 800;  //R4 - maju
                    servo[2] = 2508; //R3 - maju
                    servo[1] = 1056; //R2 - maju
                    servo[0] = 1500; //R1 - kiri                                     
                    //kaki kiri
                    servo[11] = 1500;
                    servo[10] = 1500; //L5 - kanan
                    servo[9]  = 800;  //L4 - maju    984
                    servo[8]  = 2508; //L3 - maju
                    servo[7]  = 1056; //L2 - maju
                    servo[6]  = 1500; //L1 - kanan   
                    //tangan kanan
                    servo[14] = 1200; //R3 - CW
                    servo[13] = 1000; //R2 - turun
                    servo[12] = 1800; //R1 - mundur  
                    //tangan kiri
                    servo[17]  = 1800; //L3 - CW   
                    servo[16]  = 2000; //L2 - naik
                    servo[15]  = 1200; //L1 - maju
                    delay_ms(de);       
                       
                    countTick=0;
                    tango=9;
           break;   
           
           case 9:       
                    bangkit();  
           break;
          }              
   }

void bangkit()
 {       
  langkahMax=10; 
  switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=-80;     
                            X[1]=0; Y[1]=0; Z[1]=-80; 
                            InputXYZ();   
                       break; 
                        case 1:
                            X[0]=0; Y[0]=0; Z[0]=-70;  
                            X[1]=0; Y[1]=0; Z[1]=-70; 
                            InputXYZ();     
                              
                        break;
                        case 2:
                            X[0]=0; Y[0]=0; Z[0]=-60;  
                            X[1]=0; Y[1]=0; Z[1]=-60; 
                            InputXYZ();     
                              
                        break; 
                        case 4:
                            X[0]=0; Y[0]=0; Z[0]=-50;  
                            X[1]=0; Y[1]=0; Z[1]=-50; 
                            InputXYZ();  
                        break; 
                        case 5:  
                            X[0]=0 ; Y[0]=0; Z[0]=-40;    
                            X[1]=0 ; Y[1]=0; Z[1]=-40; 
                            InputXYZ();   
                             
                        break; 
                        case 6:
                            X[0]=0; Y[0]=0; Z[0]=-30;  
                            X[1]=0; Y[1]=0; Z[1]=-30; 
                            InputXYZ();   
                                
                        break;
                        case 7:
                            X[0]=0; Y[0]=0; Z[0]=-20;  
                            X[1]=0; Y[1]=0; Z[1]=-20; 
                            InputXYZ();   
                                
                        break;    
                        case 8:
                            X[0]=0; Y[0]=0; Z[0]=-10;  
                            X[1]=0; Y[1]=0; Z[1]=-10; 
                            InputXYZ();   
                                
                        break;
                        case 9:
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();  
                             
                            sudah = 1;     
                        break;  
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>9)
                           countTick=9;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=1000; //3000  
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
                     
void maju(){
    //servoInitError[7]=30;
    //tangan kanan
    servo[14] = 1600; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1400; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=20;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:      
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:     
                            X[0]=10; Y[0]=0; Z[0]=0;    
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:   
                            X[0]=10; Y[0]=VY; Z[0]=-40;  
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 3:               
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:              
                            X[0]=-10; Y[0]=0; Z[0]=0; 
                            X[1]=10; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:              
                            X[0]=-10; Y[0]=0; Z[0]=0;   
                            X[1]=10; Y[1]=VY; Z[1]=-40; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=0; Y[0]=0; Z[0]=0;      
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>5)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=85; //65 80   85
                }   
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
}

void rotasi_kiri()
 {
    //tangan kanan
    servo[14] = 1600; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1400; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=30;
                VX=35;
                VZ=40;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=VX; Y[0]=0; Z[0]=0;    
                            X[1]=-VX; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=VX; Y[0]=VY; Z[0]=-VZ;  
                            X[1]=-VX; Y[1]=0; Z[1]=0; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=0; Y[0]=VY; Z[0]=0;  
                            X[1]=0; Y[1]=VY; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=-10; Y[0]=VY; Z[0]=0; 
                            X[1]=10; Y[1]=VY; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=-10; Y[0]=VY; Z[0]=0;   
                            X[1]=10; Y[1]=0; Z[1]=-40; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=0; Y[0]=0; Z[0]=0;      
                            X[1]=0; Y[1]=-VY; Z[1]=0; 
                            InputXYZ();      
                        break;    
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>2)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=130; //65 80 
                }   
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
 }

void rotasi_kanan()
 {
  //tangan kanan
    servo[14] = 1800; //R3 - CW
    servo[13] = 900; //R2 - turun
    servo[12] = 1900; //R1 - mundur  
    //tangan kiri
    servo[17]  = 1200; //L3 - CW   
    servo[16]  = 2050; //L2 - naik
    servo[15]  = 1100; //L1 - maju
    switch(0)     
        {  
           case 0 :     //gait  mlaku
                VY=10;
                if(counterDelay<=0)
                {         
                    switch(countTick)
                    {
                       case 0:    
                            X[0]=0; Y[0]=0; Z[0]=0;     
                            X[1]=0; Y[1]=0; Z[1]=0; 
                            InputXYZ();       
                        break;  
                        case 1:  
                            X[0]=-15; Y[0]=0; Z[0]=0;    
                            X[1]=15; Y[1]=0; Z[1]=0; 
                            InputXYZ();   
                        break; 
                        case 2:  
                            X[0]=-15; Y[0]=0; Z[0]=0;  
                            X[1]=15; Y[1]=25; Z[1]=-50; 
                            InputXYZ();      
                        break;  
                        case 3:  
                            X[0]=0; Y[0]=0; Z[0]=0;  
                            X[1]=0; Y[1]=25; Z[1]=0; 
                            InputXYZ();     
                        break;  
                        case 4:  
                            X[0]=10; Y[0]=0; Z[0]=0; 
                            X[1]=-10; Y[1]=0; Z[1]=0; 
                            InputXYZ();     
                        break; 
                        case 5:  
                            X[0]=10; Y[0]=0; Z[0]=-40;   
                            X[1]=-10; Y[1]=25; Z[1]=0; 
                            InputXYZ();   
                        break;    
                        case 6:  
                            X[0]=0; Y[0]=0; Z[0]=0;      
                            X[1]=0; Y[1]=25; Z[1]=0; 
                            InputXYZ();      
                        break;  
                    }              
                    if(VX != 0 || VY != 0 | W != 0 )
                    {
                        countTick++;
                        if(countTick>6)
                           countTick=0;     //2
                    }        
                    else 
                    {
                        countTick=0;    
                    }
                        
                    counterDelay=60; //65 80 
                }
            break; 
        } 
        
        speed=1; //10
        if(counterTG>speed)
        {            
            counterTG=0;
            taskGerakan();
        }
 }

