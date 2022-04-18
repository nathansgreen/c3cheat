# Save Edit

The save file consists of 12 JSON objects, delimited by `||`. The file is
base-64 encoded, and it appears that the first 3 bytes are just random
garbage that must be stripped prior to decoding.

There are a lot of nested arrays in the JSON structure. Most seem to be
fairly constant in length, but a few are variable.

## 0 (first JSON object)
Object 0 sets the following global variables:

0. milkMultiply
1. gcFreqM
2. gcLifeM
3. gcEffectsLifeM
4. gcWrathEffectsLifeM
5. gcWrathLifeM
6. upgradeCostM
7. allTimePlay
8. allTimeCookie
9. currentCookie
10. wrinkler
11. ascend
12. resets
13. sellGranma
14. goldenCookies
15. cPclick
16. countClick
17. clickM
18. clickMultiplyCPS
19. cookiesHandmade
20. clickNonCursor
21. cpsM
22. UnlockedShop
23. agesCookie
24. TIME_RESEACH
25. curTimeResearch
26. curResearch
27. elderPledge
28. TIME_PLEDGE
29. grandmapocalypse
30. curTimePledger

## 10

The penultimate object, at offset 10, contains the state for the 709 
possible achievements. 
