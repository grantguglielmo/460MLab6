#include <iostream>
#include <string>
#include <math.h>
#include <iomanip>
#include <bitset>
using namespace std;

float float8(int x){
	float rtn = 0;
	if(x & 0x1){
		rtn += 0.0625;
	}
	x = x >> 1;
	if(x & 0x1){
		rtn += 0.125;
	}
	x = x >> 1;
	if(x & 0x1){
		rtn += 0.25;
	}
	x = x >> 1;
	if(x & 0x1){
		rtn += 0.5;
	}
	x = x >> 1;
	int exp = x & 0x7;
	if(exp){
		rtn += 1.0;
	}
	exp = (exp + 0x5) & 0x7;
	if(exp == 0x7)
		exp = -1;
	if(exp == 0x6)
		exp = -2;
	if(exp == 0x5)
		exp = -2;
	rtn *= pow(2.0, exp);
	if(x & 0x8){
		rtn *= -1;
	}
	return rtn;
}

int main(){
	string s;
	int a, b, p;

	while(1){
		cout << "A: ";
		cin >> s;
		a = stoi(s, 0, 2);
		if(!a)
			break;
		cout << float8(a) << endl;
		// cout << "B: ";
		// cin >> s;
		// b = stoi(s, 0, 2);
		// cout << float8(b) << endl;
		// p = a * b;
		// cout << "Product: " << p << endl;
		// cout << bitset<8>(unfloat8(p)) << endl;
		// cout << "=======================" << endl;
	}

	return 0;
}