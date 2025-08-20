class FAQs {
  String question='';
  String answer='';

  FAQs({
    this.question='',
    this.answer='',
  });

  FAQs.fromJson(Map<String, dynamic> json) {
    question = json['question']??'';
    answer = json['answer']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['question'] = question;
    json['answer'] = answer;
    return json;
  }
}