var patient = assessment.current_assessment.patient;

// Block the letter generation until the user has indicated they are finished drafting, by ticking a 'done' checkbox
if (assessment.done != '1') {
  script.fatal('Generate letter first'); 
}

var letter2 = patient.create_letter({recipient: 'referral', location: patient.location})
if (letter2) {
  letter2.description = 'Letter'
  letter2.body = assessment.letter // Ensure your assessment has an element named 'letter'. This is typically best as a text area set to "rich text"
  if (!letter2.save()) {
    script.fatal('Could not save referral letter')
  } else {
    redirect(letter2); 
  }
} else {
  script.fatal("Failed to create letter")
}
