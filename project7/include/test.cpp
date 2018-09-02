#include <iostream>
#include <queue>
using namespace laomd;


int main(int argc, char const *argv[])
{
	Queue<int> q;
	for (int i = 0; i < 20; ++i)
	{
		q.push(i);
	}

	cout << q.size() << endl;

	while(!q.empty()) {
	    cout << q.front() << ' ';
	    q.pop();
	}
	cout << endl;
	return 0;
}
