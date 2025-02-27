require 'airport'
require 'weather'

describe Airport do

  let(:plane) { double :plane }
  # let(:bad_weather) { double :bad_weather, :forecast =>  "stormy" }
  describe '#land' do
    it 'allows airport to store instance of a plane' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")
      expect(subject.land(plane)[0]).to eq(plane)
    end
    it 'allows airport to store multiple planes' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")
      subject.land(plane)
      subject.land(plane)
      expect(subject.planes).to_not be_empty
    end
    it 'does not allow planes to land at full airport' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")
      airport = Airport.new(1)
      airport.land(plane)
      expect{ airport.land(plane) }.to raise_error "Airport full"
    end
    it 'does not land plane when stormy' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("stormy")
      expect{subject.land(plane)}.to raise_error "Bad weather"
    end
  end

  describe '#take_off' do
    it 'removes plane instance from airport' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")
      subject.land(plane)
      subject.take_off(plane)
      expect(subject.planes).to be_empty
    end

    it 'does not take off plane when stormy' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")
      subject.land(plane)
      allow_any_instance_of(Weather).to receive(:forecast).and_return("stormy")
      expect{subject.take_off(plane)}.to raise_error "Bad weather"
    end
  end
  
  describe '#good_weather?' do
    it 'returns false when weather is not OK to fly' do
      allow_any_instance_of(Weather).to receive(:forecast).and_return("stormy")
      expect(subject.good_weather?).to eq(false)
    end
  end

  describe '#full?' do
    it 'returns true when airport full' do
      airport = Airport.new(1)
      allow_any_instance_of(Weather).to receive(:forecast).and_return("clear")      
      airport.land(plane)
      expect(airport.full?).to eq(true)
    end
  end
end
