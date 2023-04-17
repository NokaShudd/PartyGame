import '../constants/classes.dart';
import '../constants/values.dart';

int getUnusedId({bool isTag = false}) {
  if (isTag) {
    if (alltagsId.isEmpty) {
      getAllId(allTag, alltagsId);
      if (alltagsId.isEmpty) {
        alltagsId.add(0);
        return 0;
      } else {
        int numb = getSmaller(alltagsId);
        alltagsId.add(numb);
        return numb;
      }
    }
    int numb = getSmaller(alltagsId);
    alltagsId.add(numb);
    return numb;
  }

  if (allId.isEmpty) {
    getAllId(allPlayer, allId);
    if (allId.isEmpty) {
      allId.add(0);
      return 0;
    } else {
      int numb = getSmaller(allId);
      allId.add(numb);
      return numb;
    }
  }
  int numb = getSmaller(allId);
  allId.add(numb);
  return numb;
}

void getAllId(List list, List<int> toList) {
  for (Player player in list) {
    toList.add(player.id);
  }
}

int getSmaller(List<int> list) {
  int last = 0;
  for (var i = 1; i < list.length; i++) {
    if (list[i] > last + 1) {
      return last + 1;
    }
  }
  return list.length;
}
