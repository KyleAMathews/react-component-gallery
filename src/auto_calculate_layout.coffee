
HEIGHT_DELTA = 1    # 1 px
WIDTH_DELTA = 0.1   # 0.1 px - this is for FireFox


# - Parameters:
#     data: [{width: 100, height: 200}, {width: 50, height: 100}, ...]
#     containerWidth: 1000
#     marginRight: 10
#     mainComponentIdx: 5
# - Returns:
#     sizes = 
#       widthArray: [10,20,30,40, ...]
#       height: 100
module.exports = (data = [], containerWidth = 0, marginRight = 0, mainComponentIdx = 0) ->
  length = data.length
  result = 
    widthArray: []
    height: 0

  if length and containerWidth
    mainComponent = data[mainComponentIdx]
    # component modification ratio, this is our target in calculation process
    get_k_i = (k, i, height = mainComponent.height) ->
      (k * mainComponent.height / height)

    # first of all find main component ratio
    _denominator = data.reduce(
      ((acc, item) -> 
        acc + item.width * mainComponent.height / item.height),
      0
    )
    K = (containerWidth - marginRight * (length - 1) - WIDTH_DELTA) / _denominator
    
    # result
    result.widthArray = data.map (item, i) ->
      item.width * get_k_i(K, i, item.height)
    result.height = mainComponent.height * get_k_i(K, mainComponentIdx)
    if not marginRight  # if there is no margins we can see some inaccuracy in algorithm
      result.height = result.height - HEIGHT_DELTA

  result
