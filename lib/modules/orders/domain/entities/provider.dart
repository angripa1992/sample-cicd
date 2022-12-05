class Provider{
  final int id;
  final String title;
  final String value;
  final String logo;
  bool isSelected;

  Provider(this.id, this.title, this.value, this.logo,{this.isSelected = true});

  Provider copy(){
    return Provider(id, title, value, logo,isSelected: isSelected);
  }

  Provider copyWith({required isSelected}){
    return Provider(id, title, value, logo,isSelected: isSelected);
  }
}