
#include <stdio.h>
#include <iostream>

using namespace std;

void bin(unsigned long n)
{
    unsigned long i;
    cout << "0";
    for (i = 1 << 30; i > 0; i = i / 2)
    {
        if ((n & i) != 0)
        {
            cout << "1";
        }
        else
        {
            cout << "0";
        }
    }
}

int main() {
static unsigned long ShiftRegister = 1;
 /* Все, кроме 0. */
ShiftRegister = (((ShiftRegister >> 31) ^(ShiftRegister >> 6) ^(ShiftRegister >> 4) ^(ShiftRegister >> 2) ^(ShiftRegister >> 1) ^ShiftRegister)) | (ShiftRegister >> 1);
unsigned long res =  ShiftRegister & 0x00000001;
cout << res << endl;
bin
}
