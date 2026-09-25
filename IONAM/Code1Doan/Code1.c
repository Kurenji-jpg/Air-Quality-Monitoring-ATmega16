#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#include <string.h>

#define BT1 PINC.0
#define BT2 PINC.1
#define BT3 PINC.2
#define BT4 PINC.3

#define IONAM PORTA.0

#define DHT_PIN PIND.7
#define DHT_DDR DDRD.7
#define DHT_PORT PORTD.7

char hienthi[16];

unsigned char I_RH = 0;
unsigned char I_Temp = 0;
unsigned int pm25_value = 0;

eeprom unsigned int pm25_limit = 50;
eeprom unsigned char hum_limit = 80;
bit sys_mode = 0;
bit ion_state = 0;
unsigned char menu_state = 0;

unsigned int time_10ms_cnt = 0;
unsigned int time_2s_cnt = 0;
unsigned char flag_10ms = 0;
unsigned char flag_2s = 0;

#define FRAMING_ERROR (1 << FE)
#define PARITY_ERROR (1 << UPE)
#define DATA_OVERRUN (1 << DOR)
unsigned char rx_buffer[7];
unsigned char rx_index = 0;

interrupt[TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0 = 0x83;

    time_10ms_cnt++;
    if (time_10ms_cnt >= 10)
    {
        time_10ms_cnt = 0;
        flag_10ms = 1;
    }

    time_2s_cnt++;
    if (time_2s_cnt >= 2000)
    {
        time_2s_cnt = 0;
        flag_2s = 1;
    }
}

interrupt[USART_RXC] void usart_rx_isr(void)
{
    unsigned char status;
    unsigned char data;

    status = UCSRA;
    data = UDR;

    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
    {
        if (rx_index == 0 && data != 0xFE)
            return;
        if (rx_index == 1 && data != 0xA5)
        {
            rx_index = 0;
            return;
        }

        rx_buffer[rx_index] = data;
        rx_index++;

        if (rx_index >= 7)
        {
            pm25_value = (rx_buffer[4] << 8) | rx_buffer[5];
            rx_index = 0;
        }
    }
}

void DHT_Start(void)
{
    DHT_DDR = 1;
    DHT_PORT = 0;
    delay_ms(20);
    DHT_DDR = 0;
    DHT_PORT = 1;
}
unsigned char DHT_CheckResponse(void)
{
    unsigned int timeout = 0;
    delay_us(40);
    if (DHT_PIN == 0)
    {
        timeout = 0;
        while (DHT_PIN == 0)
        {
            if (++timeout > 1000)
                return 0;
        }
        timeout = 0;
        while (DHT_PIN == 1)
        {
            if (++timeout > 1000)
                return 0;
        }
        return 1;
    }
    return 0;
}
unsigned char DHT_ReadByte(void)
{
    unsigned char i;
    unsigned char data = 0;
    unsigned int timeout;
    for (i = 0; i < 8; i++)
    {
        timeout = 0;
        while (DHT_PIN == 0)
        {
            if (++timeout > 1000)
                break;
        }
        delay_us(30);
        if (DHT_PIN == 1)
        {
            data = (data << 1) | 1;
            timeout = 0;
            while (DHT_PIN == 1)
            {
                if (++timeout > 1000)
                    break;
            }
        }
        else
        {
            data = (data << 1);
        }
    }
    return data;
}

void Doc_DHT11(void)
{
#asm("cli")
    DHT_Start();
    if (DHT_CheckResponse() == 1)
    {
        I_RH = DHT_ReadByte();
        DHT_ReadByte();
        I_Temp = DHT_ReadByte();
        DHT_ReadByte();
        DHT_ReadByte();
    }
#asm("sei")
}

void YeuCau_Doc_PM25(void)
{
    rx_index = 0;
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = 0xFE;
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = 0xA5;
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = 0x00;
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = 0x00;
    while (!(UCSRA & (1 << UDRE)))
        ;
    UDR = 0xA5;
}

void Quet_NutBam(void)
{
    if (BT1 == 0)
    {
        delay_ms(20);
        if (BT1 == 0)
        {
            while (BT1 == 0)
                ;
            menu_state++;
            if (menu_state > 2)
                menu_state = 0;
            lcd_clear();
        }
    }
    if (BT4 == 0)
    {
        delay_ms(20);
        if (BT4 == 0)
        {
            while (BT4 == 0)
                ;
            if (menu_state == 0)
                sys_mode = !sys_mode;
        }
    }

    if (BT2 == 0)
    {
        delay_ms(20);
        if (BT2 == 0)
        {
            if (menu_state == 1)
                pm25_limit += 5;
            else if (menu_state == 2)
            {
                if (hum_limit < 100)
                    hum_limit++;
            }
            else if (menu_state == 0 && sys_mode == 1)
                ion_state = 1;
            delay_ms(150);
        }
    }

    if (BT3 == 0)
    {
        delay_ms(20);
        if (BT3 == 0)
        {
            if (menu_state == 1)
            {
                if (pm25_limit >= 5)
                    pm25_limit -= 5;
                else pm25_limit = 5;
            }
            else if (menu_state == 2)
            {
                if (hum_limit >= 1)
                    hum_limit--;
                else hum_limit = 0;
            }
            else if (menu_state == 0 && sys_mode == 1)
                ion_state = 0;
            delay_ms(150);
        }
    }
}

void XuLy_Logic(void)
{
    if (I_RH >= hum_limit && I_RH <= 100)
    {
        IONAM = 0;
        ion_state = 0;
    }
    else
    {
        if (sys_mode == 0)
        {
            if (pm25_value >= pm25_limit)
                IONAM = 1;
            else if (pm25_value < pm25_limit - 5)
                IONAM = 0;
        }
        else
            IONAM = ion_state;
    }
}

void HienThi_LCD(void)
{
    if (menu_state == 0)
    {
        if (I_RH >= hum_limit && I_RH <= 100)
        {
            lcd_gotoxy(0, 0);
            lcd_puts("! CANH BAO AM ! ");
            lcd_gotoxy(0, 1);
            lcd_puts(" HE THONG TAT   ");
        }
        else
        {
            sprintf(hienthi, "T:%d%cC H:%d%% [%c] ", I_Temp, 0xdf, I_RH, (sys_mode == 0 ? 'A' : 'M'));
            lcd_gotoxy(0, 0);
            lcd_puts(hienthi);

            if (IONAM == 1)
            {
                sprintf(hienthi, "PM:%d  ION:ON ", pm25_value);
            }
            else
            {
                sprintf(hienthi, "PM:%d  ION:OFF", pm25_value);
            }
            lcd_gotoxy(0, 1);
            lcd_puts(hienthi);
        }
    }
    else if (menu_state == 1)
    {
        lcd_gotoxy(0, 0);
        lcd_puts("> CAI DAT BUI < ");
        sprintf(hienthi, "Nguong: %d ug/m3", pm25_limit);
        lcd_gotoxy(0, 1);
        lcd_puts(hienthi);
    }
    else if (menu_state == 2)
    {
        lcd_gotoxy(0, 0);
        lcd_puts("> CAI DO AM  <  ");
        sprintf(hienthi, "Nguong: %d %%   ", hum_limit);
        lcd_gotoxy(0, 1);
        lcd_puts(hienthi);
    }
}

void main(void)
{
DDRA = 0x01;
PORTA = 0x00;
DDRB = 0xFF;
PORTB = 0x00;
DDRC = (0 << DDC7) | (0 << DDC6) | (0 << DDC5) | (0 << DDC4) | (0 << DDC3) | (0 << DDC2) | (0 << DDC1) | (0 << DDC0);
PORTC = (0 << PORTC7) | (0 << PORTC6) | (0 << PORTC5) | (0 << PORTC4) | (1 << PORTC3) | (1 << PORTC2) | (1 << PORTC1) | (1 << PORTC0);
DDRD = 0x02;
PORTD = 0x10;

TCCR0 = (0 << WGM00) | (0 << COM01) | (0 << COM00) | (0 << WGM01) | (0 << CS02) | (1 << CS01) | (1 << CS00);
TCNT0 = 0x83;
OCR0 = 0x00;

TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << TOIE1) | (0 << OCIE0) | (1 << TOIE0);

UCSRA = (0 << RXC) | (0 << TXC) | (0 << UDRE) | (0 << FE) | (0 << DOR) | (0 << UPE) | (0 << U2X) | (0 << MPCM);
UCSRB = (1 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN) | (0 << UCSZ2) | (0 << RXB8) | (0 << TXB8);
UCSRC = (1 << URSEL) | (0 << UMSEL) | (0 << UPM1) | (0 << UPM0) | (0 << USBS) | (1 << UCSZ1) | (1 << UCSZ0) | (0 << UCPOL);
UBRRH = 0x01;
UBRRL = 0xA0;

lcd_init(16);
lcd_clear();

#asm("sei")

    while (1)
    {
        if (flag_10ms)
        {
            flag_10ms = 0;
            Quet_NutBam();
            XuLy_Logic();
            HienThi_LCD();
        }

        if (flag_2s)
        {
            flag_2s = 0;
            Doc_DHT11();
            YeuCau_Doc_PM25();
        }
    }
}