class Person {
  num age;
  num height;
  num? weight;
  Person(this.age, this.height);

  num getIdealWeight(String gender) {
    // Calculate ideal weight based on gender
    /*
      if male weight = height / age * 10
      if female weight = height / age * 9
       */
    if (gender.toLowerCase() == 'male') {
      return height / age * 10;
    } else if (gender.toLowerCase() == 'female') {
      return height / age * 9;
    } else {
      // Default case if gender is not specified or invalid
      return 0;
    }
  }
}
