enum QuestRank { troublesome, dangerous, formidable, extreme, epic }

class Quest {
  late String name;
  late QuestRank rank;
  int progress = 0;

  Quest(this.name, this.rank);
}
