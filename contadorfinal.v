module JK(output reg Q,output wire nQ, input wire J, input wire K, input wire C);
	initial Q=0;
	not(nQ,Q);
	always @(negedge C)
		case({J,K})
			2'b01: Q=0;
			2'b10: Q=1;
			2'b11: Q=~Q;
		endcase
	endmodule
	
module CONTADOR(output wire[3:0]Q, input wire C);
	wire [3:0]nQ;
	
	wire aJ3_1, aJ3_2, oJ3;		wire aK3_1, aK3_2, oK3;
	wire aJ2_1, aJ2_2, oJ2;		wire oK2;
	wire oJ1;	       		wire aK1_1, aK1_2, aK1_3, oK1;
	wire aJ0_1, aJ0_2, oJ0;		wire aK0_1, aK0_2, aK0_3, oK0;
	
	
	not n0(nQ[0],Q[0]);
	not n1(nQ[1],Q[1]);
	not n2(nQ[2],Q[2]);
	not n3(nQ[3],Q[3]);
	
	
	//J3
	and a1 (aJ3_1, Q[0], Q[2]);
	and a2 (aJ3_2, Q[1], Q[0]);
	or o1 (oJ3, aJ3_1, aJ3_2);
	
	//K3
	and a3 (aK3_1, nQ[2], Q[0]);
	and a4 (aK3_2, Q[2], nQ[0]);
	or o2 (oK3, aK3_1, aK3_2, Q[1]);
	
	//J2
	and a5 (aJ2_1, nQ[1], nQ[0], Q[3]);
	and a6 (aJ2_2, Q[1], nQ[3]);
	or o3 (oJ2, aJ2_1, aJ2_2);
	
	//K2
	or o4 (oK2, nQ[3], Q[0], Q[1]);
	
	//J1
	or o5 (oJ1, nQ[3], Q[2], Q[0]);
	
	//K1
	and a7 (aK1_1, nQ[3], nQ[2]);
	and a8 (aK1_2, Q[0], nQ[3]);
	and a9 (aK1_3, Q[0], nQ[2]);
	or o6 (oK1, aK1_1, aK1_2, aK1_3);
	
	//J0
	and a10 (aJ0_1, Q[1], nQ[3], nQ[2]);
	and a11 (aJ0_2, nQ[1], Q[3]);
	or o7 (oJ0, aJ0_1, aJ0_2);
	
	//K0
	and a12 (aK0_1, nQ[3], Q[1]);
	and a13 (aK0_2, Q[2], Q[1]);
	and a14 (aK0_3, nQ[1], Q[3]);
	or o8 (oK0, aK0_1, aK0_2, aK0_3);
	
	//CONTADOR
	JK JKO(Q[0],nQ[0], oJ0, oK0, C);
	JK JK1(Q[1],nQ[1], oJ1, oK1, C);
	JK JK2(Q[2],nQ[2], oJ2, oK2, C);
	JK JK3(Q[3],nQ[3], oJ3, oK3, C);
endmodule
 
module CAMBIO (output wire [3:0] Q,input wire [3:0] I);
	wire [3:0] nI;
	
	wire aQ3_1;
	wire aQ2_1, aQ2_2, aQ2_3;
	wire aQ1_1;
	wire aQ0_1,aQ0_2,aQ0_3;

	not n4(nI[0],I[0]);
	not n5(nI[1],I[1]);
	not n6(nI[2],I[2]);
	not n7(nI[3],I[3]);

	//CAMBIOS 1--> 3 3--> 11 7-->2
	
	//Q3
	and a15 (aQ3_1, nI[2], I[1], I[0]);
	or o9 (Q[3], aQ3_1, I[3]);
	
	//Q2
	and a16 (aQ2_1, I[2], nI[1]);
	and a17 (aQ2_2, I[2], nI[0]);
	and a18 (aQ2_3, I[3], I[2]);
	or o10 (Q[2], aQ2_1, aQ2_2, aQ2_3);
	
	//Q1
	and a19 (aQ1_1, nI[3], nI[2], I[0]);
	or o11 (Q[1], aQ1_1, I[1]);
	
	//Q0
	and a20 (aQ0_1, I[3], I[0]);
	and a21 (aQ0_2, nI[2], I[1], I[0]);
	and a22 (aQ0_3, nI[1], I[2], I[0]);
	or o12 (Q[0], aQ0_1, aQ0_2, aQ0_3);

endmodule

/*module test1;  //Modulo de prueba para el cambio 

	reg [3:0] Original;
	wire [3:0] Transformado;

	CAMBIO c1(Transformado,Original);

	initial
		begin
			$monitor($time," %d->%d",Original,Transformado);

			Original=0;
			while(Original!=15)
				#5 Original=Original+1;
		end
endmodule*/
		


module TEST;  //Módulo de prueba para el contador y prueba en GTKWave
	
	wire [3:0]O;
	reg C;

	CONTADOR CA(O,C);

	wire [3:0] cambio;
	CAMBIO io(cambio,O);
	always #5 C=~C;
	


	initial
		begin
			$dumpfile("pruebaGTK.dmp");
			$dumpvars;
				$display("PRUEBA"); 
				C=0;
				$monitor($time,"C: %b 					(%d)",cambio,cambio);

				#105;
			$dumpoff;
	$finish; 
	end
endmodule


