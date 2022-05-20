public abstract inherited sharing class Animal {

    protected String animalName;
    public String getName() {
        return this.animalName;
    }

    public Animal(String animalName) {
        this.animalName = animalName;
    }

    public abstract void makeNoise();
    public abstract void move();
}