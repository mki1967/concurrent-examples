/* Dużo wątków */

import java.util.Random;

public class MyRunnable1 implements Runnable {
    public static final int MAX_THREADS=4;

    int id;
    Random rand;

    /* global random generator for initialisation 
       of local threads generators */
    static Random globalRand = new Random(System.currentTimeMillis());

    public MyRunnable1(int identifier){
	id = identifier;
        rand = new Random( globalRand.nextLong() );
    }

    void mySleep(int millis){
	try{
	    Thread.sleep(millis);
	} catch( InterruptedException e ) {
	    /* handle e */
	}
    }

    public void run(){
	for(int i=0; i<1000; i++) {
	    mySleep( 100+rand.nextInt(3000));
	    System.out.println("Runnable"+id+": "+i);
	}
    }

    public static void main(String args[]) {
	for(int i = 0; i < MAX_THREADS; i++){
	    (new Thread(new MyRunnable( i ))).start();
	}
    }

}
