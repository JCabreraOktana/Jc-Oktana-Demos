public with sharing class Horse extends Animal{
    
    public Horse() {
        super('Horse');
    }
    public override void makeNoise() {
        System.debug(getName() + ' is nighing');
    }
    public override void move() {
        System.debug(getName() + ' is sliding');
    }

}