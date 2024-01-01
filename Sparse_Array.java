import java.util.Scanner; 

class Sparse_Array { 

	static Scanner in = new Scanner(System.in);
		
	public static void main (String args[]) {
		
		int i, mikosA=0, mikosB=0, mikosC=0, op;		
		int [] pinA = new int [10];
		int [] pinB = new int [10];
		int [] SparseA = new int [20];
		int [] SparseB = new int [20];
		int [] SparseC = new int [20];

		op=readOption();

		while((op>=1) && (op<=8)){
			switch (op) {
				case 1: System.out.println ("Reading Array A");
						readPin(pinA);
					break;
				case 2: System.out.println ("Reading Array B");
						readPin(pinB);
					break;
				case 3: System.out.println ("Creating Sparse Array A" );
						mikosA= createSparse (pinA,SparseA);
						System.out.println ( (mikosA/2) + " values" );
					break;
				case 4: System.out.println ("Creating Sparse Array B" );
						mikosB= createSparse (pinB,SparseB);
						System.out.println ( (mikosB/2) + " values" );
					break;
				case 5: System.out.println ("Creating Sparse Array C = A + B");
						mikosC = addSparse (SparseA, mikosA, SparseB, mikosB, SparseC);
						System.out.println ( (mikosC/2) + " values" ); 
					break;
				case 6: System.out.println ("Displaying Sparse Array A");
						printSparse(SparseA, mikosA);
					break;
				case 7: System.out.println ("Displaying Sparse Array B");
						printSparse(SparseB, mikosB);
					break;
				case 8: System.out.println ("Displaying Sparse Array C");
						printSparse(SparseC, mikosC);
					break;
			}
			op=readOption();
		}//while
	}//main
	
	static int readOption() 
	{	System.out.println	("\n-----------------------------");
		System.out.println 	("1. Read Array A");
		System.out.println 	("2. Read Array B");
		System.out.println 	("3. Create Sparse Array A" );
		System.out.println 	("4. Create Sparse Array B" );
		System.out.println 	("5. Create Sparse Array C = A + B");		
		System.out.println 	("6. Display Sparse Array A");
		System.out.println 	("7. Display Sparse Array B");
		System.out.println 	("8. Display Sparse Array C");	
		System.out.println 	("0. Exit");
		System.out.println	("\n-----------------------------");
		System.out.print 	("Choice? ");
		int Answer=in.nextInt();
		return Answer;
	}//readoption

	static int addSparse (int [] SparseA, int mikosA, int [] SparseB, int mikosB, int [] SparseC) 
	{	
		int a,b,c;	
		for (a=0, b=0, c=0; a<mikosA && b<mikosB; ) 	
				if (SparseA[a] < SparseB [b]) {	
					SparseC [c++] = SparseA[a++];
					SparseC [c++] = SparseA[a++];	
				}	
				else if (SparseA[a] > SparseB [b]) {	
							SparseC [c++] = SparseB[b++];
							SparseC [c++] = SparseB[b++];
						}			
				else 	{	
							SparseC [c++] = SparseA[a++]; 
							b++;
							SparseC [c++] = SparseA[a++] + SparseB[b++];
						}
				
		for (;a<mikosA;)
		{
				SparseC [c++] = SparseA[a++];
				SparseC [c++] = SparseA[a++];
				
		}
		for (;b<mikosB;)
		{
				SparseC [c++] = SparseB[b++];
				SparseC [c++] = SparseB[b++];
		}   	
		return c;   	
	} //addSparse
	
	static void readPin(int [] pin) {
		for (int i=0; i<pin.length; i++) {
			System.out.print ("Position " + i +" :");
			pin [i] = in.nextInt();
		}
	} //readPin
	
	static void printSparse (int [] Sparse, int mikos)	{
		for (int i=0; i<mikos;)
			System.out.println ("Position: " + Sparse [i++] + " Value: " + Sparse [i++]);
	} //printSparse
	
	static int createSparse (int [] pin, int [] Sparse) {
		int i, k=0;
		for (i=0; i<pin.length; i++)
			if (pin [i] != 0){
				Sparse [k++] = i;
				Sparse [k++] = pin [i];
			}
		return k;
	}// createSparse
	
}