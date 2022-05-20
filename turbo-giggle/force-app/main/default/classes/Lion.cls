public with sharing class Lion extends Animal implements SwimmerAnimal{
    
    public Lion() {
        super('Lion');
    }
    public override void makeNoise() {
        System.debug(getName() + ' is roaring');
    }
    public override void move() {
        System.debug(getName() + ' is moving');
    }
    public void swim(){
        doSwim();
    }

    private void doSwim(){
        System.debug(getName() + ' is swimming');
    }
}