library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity PWM_Signal is		
	 port(
	 	 CLK_SOURCE : 	in STD_LOGIC;	--	Reloj con frecuencia de 257.6 kHz
	 	 CLK_UPDATE	:	in STD_LOGIC;	--	Reloj para actualizar el valor de la cuenta con frecuencia de 100 Hz
		 RST : 		in STD_LOGIC;	--	Reset 
		 --LEDS : 	out STD_LOGIC_VECTOR(9 downto 0);	--	Vector de 8 bits para seleccionar la posición 
		 TEST_PIN :	out STD_LOGIC
	     );
end PWM_Signal;

architecture Behavioral of PWM_Signal is
	-- Realizar una cuenta de 0 a 258 usando una frecuencia base de 257.6 kHz
	signal counter : unsigned(8 downto 0);
	-- LLeva la cuenta comparativa del valor de acuerdo al ciclo de trabajo del PWM
	signal pwm_counter : unsigned(8 downto 0);
	-- Señal pwm de salida
	signal pwm : std_logic := '0';
	signal pwm_f : std_logic := '0';
	-- Revisar el estado de la secuencia
	signal flag : std_logic := '0';

begin	
	
	--LEDS <= (others => pwm_f);
	TEST_PIN <= pwm_f;
	
	Update: process( CLK_SOURCE ) begin
		if( RST = '1') then
			counter <= (others => '0');			
		elsif rising_edge( CLK_SOURCE ) then
			if( counter = 258) then 
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	Sequence: process( CLK_UPDATE ) begin
		if( RST = '1') then
			pwm_counter <= (others => '0');			
		elsif rising_edge( CLK_UPDATE ) then
			if( pwm_counter = 256) then 
				pwm_counter <= (others => '0');
				flag <= NOT(flag);
			else
				pwm_counter <= pwm_counter + 1;
			end if;
		end if;
	end process;
	
	Flag_Checked: process( flag ) begin
		if( flag = '0') then
			pwm_f <= pwm;
		else
			pwm_f <= NOT(pwm);
		end if;
	end process;
	
	Comparative:process( RST, counter, pwm_counter ) begin
		if(RST = '1') then
			pwm <= '0';
		else
			if( counter < pwm_counter) then 
				pwm <= '1';
			else
				pwm <= '0';
			end if;
		end if;
	end process;		
	
			   
end Behavioral;