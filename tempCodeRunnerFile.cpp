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
