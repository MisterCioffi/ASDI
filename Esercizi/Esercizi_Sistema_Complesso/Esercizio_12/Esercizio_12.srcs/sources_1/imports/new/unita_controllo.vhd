library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity unita_controllo is 
	port( q0, clock, reset, start: in std_logic;--clock � il clock della board, clock_div viene dal divisore di freq
		  count: in std_logic_vector(1 downto 0);
		  loadM, count_in, loadAQ, en_shift: out std_logic;
		  selM, selAQ, selF, subtract, stop_cu: out std_logic;
		  reset_init: out std_logic); -- reset_op � un segnale di reset per i registri interni all'inizio di un'operazione di moltiplicazione
end unita_controllo;


architecture structural of unita_controllo is
	type state is (idle, acquisisci_op, avvia_somma, avvia_shift, incr_count, avvia_fshift, fine);
	signal current_state,next_state: state;

	begin 

	selM <= q0;-- in ogni istante la selezione del mux � data dal bit meno significativo di A.Q (q0)
	
		
	reg_stato: process(clock)
			  begin
			  if(clock'event and clock='1') then
		         if(reset='1') then 
				    current_state <=idle;
			    else 
				    current_state <=next_state;
			     end if;
			  end if;
			  end process;
			  
	comb: process(current_state, start, count, q0)
		  begin
		  
		  -- Attenzione! questo process si attiva ogni volta che c'� una variazione nei segnali della sensitivity list
		  -- current_state e count per loro natura variano sempre in corrispodenza del fronte di salita del clock
		  -- start viene dall'esterno: se non varia (sale e scende) col fronte del clock, si potrebbe avere una situazione
		  -- in cui il next_state varia ma non ha modo da stabilizzarsi (perch� current_state non � ancora variato)
		  -- quando il moltiplicatore sar� messo su board, START dovr� essere generato come uscita del button debouncer
		  
		 count_in <='0'; 
         subtract <='0';
         selAQ <= '0';
         selF <= '0';
         loadAQ <='0';  --carica nello shift register
         loadM <='0';   --carica il moltiplicando nel registro M
         stop_cu <='0';  
         en_shift <='0'; --segnale che abilita lo shift durante le prime N-1 iterazioni
         reset_init <='0'; --segnale di reset per i registri all'inizio di un'operazione di moltiplicazione
		  	            
	     CASE current_state is
		  
		  WHEN idle => 
		  
		            
                  if(start='1') then 
				  	   reset_init <='1'; 
					   next_state <= acquisisci_op;
				    else 
					   next_state <= idle;
					end if;
		
		  --fornisce i segnali di caricamento operandi
		  WHEN acquisisci_op => 

		             
		            loadM <='1'; --abilita il caricamento del moltiplicando nel registro M
		            
					loadAQ <='1'; --abilita il caricamento del moltiplicatore e degli 8 zeri in testa 
					              --nello shift register A.Q (perch� selAQ=0)
					
					next_state <= avvia_somma;
						
		--acquisisce gli operandi, su cui il sommatore inizia a lavorare immediatamente
		 WHEN avvia_somma => 

		            selAQ <= '1';
		            loadAQ <= '1'; --fornisce il segnale di caricamento in A del risultato della somma
					    
					if(count="11") then
					    if(q0='1') then
						    subtract <='1'; --se questa � l'ultima iterazione avvio una sottrazione e vado in final shift
						end if;
						next_state <= avvia_fshift;
					    
					else 
					    next_state <= avvia_shift;
					end if;
		
		 --carica il risultato della somma in A e da fornisce il segnale di shift
		 WHEN avvia_shift =>  

					en_shift <='1';
					  
					next_state <= incr_count;
					  
		 --esegue lo shift, abilita incremento conteggio e predispone per nuova iterazione  
		 WHEN incr_count => 
		             
		            count_in <= '1';
					  
					next_state <= avvia_somma;
	
	     --in correzione fa la sottrazione e predispone per l'ultimo shift
		 WHEN avvia_fshift =>	
					 
					 en_shift <= '1';
					 selF <= '1';
							
					 next_state <= fine;
		
		 WHEN fine => 
		      		
                     stop_cu <='1';
		      		  
                     next_state <= idle;
		end CASE;
		
    end process; 
 end structural;