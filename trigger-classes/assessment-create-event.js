var patient = assessment.patient
var event =  patient.add_event({
  start_date: new Date(), 
  end_date: new Date(new Date().getTime() + 24 * 60 * 60 * 1000), // What was the end date of the event; for time tracking purposes?
  staff_member: 43, // Who the event is billed for. Use a service provider picker or the current_user.staff_member if they are a provider.
  service_location: 2 // Which service location is associated?
});
console.log(event);

var service = event.create_general_service({
  item: "ZP204", // Add a fictional, non MBS item number you have configured via Admin > Items. Optional for general service.
  cost: 12.5, // Add an optional cost
  note: "Gave the patient a new ZP204 and instructed on use"
});

console.log(service);
