library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity servo_signal is		
	 port(
		 CLK : 		in STD_LOGIC;	--	Reloj con frecuencia de 128 kHz
		 RST : 		in STD_LOGIC;	--	Reset 
		 POS : 		in STD_LOGIC_VECTOR(7 downto 0);	--	Vector de 8 bits para seleccionar la posición
		 SERVO :    out STD_LOGIC
	     );
end servo_signal;

architecture Behavioral of servo_signal is
	-- Realizar una cuenta de 0 a 2560 usando una frecuencia base de 128 kHz
	signal counter : unsigned(11 downto 0);
	-- Señal de comparación para el pulso PWM del servomotor
	signal servo_s : unsigned(8 downto 0);
	
begin	
	
	-- Garantizar que el valor mínimo en alto sea de 0.5 ms	
	servo_s <= unsigned( '0' & POS ) + 64;	
	
	Update:process( RST, CLK )begin 
		if( RST = '1') then
			counter <= (others => '0');			
		elsif rising_edge( CLK ) then
			if( counter = 2560) then 
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	Comparative:process( RST, counter, servo_s ) begin
		if(RST = '1') then
			SERVO <= '0';
		else
			if( counter < servo_s) then 
				SERVO <= '1';
			else
				SERVO <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;
