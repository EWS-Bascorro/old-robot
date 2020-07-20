
 
Satu 1 DETIK = 45,45

cari bola ada codingan SIAP || case 1 
 

INVERS KINEMATIK

    //kaki kanan  (gerakan per servo)                 
    sudutSet[5]  = pinggul (kanan kiri)        90++ depan keluar
    sudutSet[4]  = pinggang (mask keluar)      95--         //// tidak berubah apa-apa
    sudutSet[3]  = paha(edit dibawah)          70++ semakin mundur(jejeg)
    sudutSet[2]  = dengkul (depan belakang)    90-- semakin jejeg(keatas)
    sudutSet[1]  = engkel (depan belakang)     96--depan naik 
    sudutSet[0]  = Telapak(kanan kiri)         100-- luar naik
    
                                       
    //kaki kiri
    sudutSet[11]  = pinggul (kanan kiri)        85-- depankeluar
    sudutSet[10]  = pinggang (depan belakag)    95-- kedalem
    sudutSet[9]   = paha(edit dibawah)          75-- maju nendang
    sudutSet[8]   = dengkul (depan belakang)    90-- semakin jejeg
    sudutSet[7]   = engkel (depan belakang)     90--depan naik
    sudutSet[6]   = Telapak(kanan kiri)         95-- luar naik
    
                             
                             
    //KAKI KANAN
    servoInitError[0]=-65;      //-- luar keatas
    servoInitError[1]=0;    //-- depan naik
    servoInitError[2]=0;      //-- kedepan
    servoInitError[3]=-35;      //-- kedepan (++ jejeg)
    servoInitError[4]=0;      //++ keluar
    servoInitError[5]=0;      //++depan keluar
    
    KAKI KIRI
    servoInitError[6]=-43;      //-- luar keatas
    servoInitError[7]=0;      //-- depan naik
    servoInitError[8]=0;      //-- kedepan
    servoInitError[9]=-35;      //-- kedepan (++ jejeg)
    servoInitError[10]=0;      //++ keluar
    servoInitError[11]=0;      //-- depan keluar
    
    TANGAN KANAN
    servoInitError[12]=0;      //++ maju
    servoInitError[13]=0;      //++ keatas
    servoInitError[14]=0;      //++ kedepan
    
    TANGAN KIRI
    servoInitError[15]=0;      //-- maju
    servoInitError[16]=0;      //-- keatas
    servoInitError[17]=0;      //--keluar


Gerakan x y z kaki (IK + FORWARD)

    0 = kanan
    1 = kiri
    x kanan kiri  = ++ keluar
    y maju        = ++ maju
    z atas bawah  = -- keatas
    servo[5]      = pinggunl kanan  90++ keluar (kekanan)
    servo[11]     = pinggul kiri    85-- keluar (kekiri)
    
Gerakan tangan (FORWARD)

    //tangan kanan
    servo[14] = dalam; //1350-- mundur
    servo[13] = tengah; //900-- turun
    servo[12] = luar 1900-- mundur  
    //tangan kiri
    servo[17]  = dalam; //1650--maju   
    servo[16]  = tengah; //2050--keatas  
    servo[15]  = luar; //1100++mundur 
    
Gerakan Kepala

    servo[18]  = leher  (kiri kanan) ++
    servo[19]  = kepala (ats bawah)  ++
     
