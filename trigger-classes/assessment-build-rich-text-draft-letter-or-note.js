var patient = assessment.current_assessment.patient;
var name = patient.given_name;

var date = '';
if (assessment.operation_date != '') {
  loc = '<b>Operation Date</b>' + assessment.operation_date + '<br/>';
}

var diag = '';
if (assessment.clinical_note != '') {
  diag = '<b>Diagnosis</b>' + '<p>'+assessment.clinical_note+'</p>';
}

var lines = [
  "<center><h1>Consultation Report</h1></center><br/>",
  '<b>'+patient.display_name+' DOB:'+builder.date.build(patient.dob).as_string +'<br/>',
  patient.home_address.request_address+'</b><br/><br/>',
  diag
];
assessment.letter =  lines.join("\n")


assessment.done = '1';
assessment.save()
