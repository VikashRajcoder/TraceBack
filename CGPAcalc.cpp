#include <bits/stdc++.h>
using namespace std;

double cgpa_calc(double marks[], int n){
    double grade[n];
    double cgpa, sum=0;
    for(int i=0; i<n; i++){
        grade[i] = marks[i]/10;
    }

    // sum of grades
    for(int i=0; i<n; i++){
        sum += grade[i];
    }
    // CGPA
    cgpa = sum/n;
    return cgpa;
}

int main(){
    int n; cin >> n;
    double marks[n];
    for(int i=0; i<n; i++){
        cin >> marks[i];
    }
    double cgpa = cgpa_calc(marks,n);
    cout << "CGPA= " ;
    printf("%.2f",cgpa);
    cout << "\nCGPA per= ";
    printf("%.2f",cgpa*10);

}
