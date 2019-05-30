Generating the repos.txt file.

```
for i in `seq 1 40`; \
  do ghi show $i | \
  grep https | \
  head -1 | \
  sed -ne 's/.*\(http[^" ]*\).*/\1/p' >> repos.txt; \
  echo $i; \
done
```