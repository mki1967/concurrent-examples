/* Wspólna zmienna */

import java.util.Random;

public class MyRunnable2 implements Runnable {
    public enum Type  {
	READER,
	WRITER
    };

    static volatile long sharedVariable; // volatile zapewnia atomowy dostęp

    int id;
    Random rand;
    Type type;



    /* global random generator for initialisation 
       of local threads generators */
    static Random globalRand = new Random(System.currentTimeMillis());

    public MyRunnable2(int identifier, Type runnableType){
	id = identifier;
	type = runnableType;
        rand = new Random( globalRand.nextLong() );
    }

    void mySleep(int millis){
	try{
	    Thread.sleep(millis);
	} catch( InterruptedException e ) {
	    /* handle e */
	}
    }

    public void runReader(){
        long value;
	for(int i=0; i<1000; i++) {
	    mySleep( 100+rand.nextInt(3000));
            value = sharedVariable;
	    System.out.println("Runnable"+id+": read "+value);
	}
    }
    public void runWriter(){
        long value;
	for(int i=0; i<1000; i++) {
	    mySleep( 100+rand.nextInt(3000));
            value = rand.nextLong();
	    System.out.println("Runnable"+id+": writing "+value);
            sharedVariable = value;
	}
    }
    public void run(){
        switch(type){
	case READER:
	    runReader();
	    break;
	case WRITER:
	    runWriter();
	    break;
	}
    }

    public static void main(String args[]) {
        (new Thread(new MyRunnable2( 1, MyRunnable2.Type.READER ))).start();
        (new Thread(new MyRunnable2( 2, MyRunnable2.Type.WRITER ))).start();
    }

}
