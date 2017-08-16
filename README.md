# README #



### What is this repository for? ###

* Discount Project
* Version 1.0-SNAPSHOT
* http://rbtechnologies.ru

### How do I get set up? ###

> ##### Note! 
> Be sure you have Java 8 SDK installed.  
> Be sure you have Oracle WebLogic 12.2.1.2 installed.  
> Be sure you have GitBash console in Windows or Linux bash console

```{r, engine='bash', count_lines}
mkdir -p ~/src
cd ~/src
```

### Install open tag libraries to you .m2 utilized by frontend components ###
Only for the first time compilation.
For more information follow: https://github.com/m1ab/tag/blob/dev/README.md
```{r, engine='bash', count_lines}
git clone https://github.com/m1ab/tag.git && \
cd tag && \
git checkout dev && \
mvn clean install -Ptotal -T4 && \
cd -
```

### Install open IFRS libraries to you .m2 ###
This package contains classes with functions
for calculating various financial indicators
in accordance with the international financial
reporting standards IFRS.
Only for the first time compilation
For more information follow: https://github.com/RBTechnologies/ifrs/blob/dev/README.md
```{r, engine='bash', count_lines}
git clone https://github.com/RBTechnologies/ifrs.git && \
cd ifrs && \
git checkout dev && \
mvn clean install -Ptotal -T4 && \
cd -
```

### Build project discount and copy discount-app-1.0-SNAPSHOT.ear to WebLogic autodeploy folder ###
```{r, engine='bash', count_lines}
git clone https://github.com/RBTechnologies/discount.git && \
cd discount && \
mvn clean install -Ptotal -T4 && \
    cp ./discount-app/target/discount-app-1.0-SNAPSHOT.ear \ 
    /c/Oracle/user_projects/domains/base_domain/autodeploy/ && \
cd -
```

### Build project discount with GWT module ###
```{r, engine='bash', count_lines}
mvn clean install -Ptotal-gwt -T4
```

> ##### Note!
> If you don't wanna user temp dir (on your silly ssd) be trashed up with a gwt-cache-garbage
> use some settings described below.
> Edit your maven settings.xml

```{r, engine='xml', count_lines}
  <profiles>
    ....
	<profile>
		....
		<id>artifactory</id>
		....
		<properties>
			<gwt-plugin-trash-dir>d:\tmp</gwt-plugin-trash-dir>
		</properties>
	</profile>
	....
  </profiles>

  <activeProfiles>
    <activeProfile>artifactory</activeProfile>
  </activeProfiles>
```

### Build project discount with JSF module (prime faces) ###
```{r, engine='bash', count_lines}
mvn clean install -Ptotal-prime -T4
```

> ##### Note!
> You have to configure XA database connection 
> with the name: "/jdbc/discountDS".  

### Init database tables sequences and default inserts with:
```{r, engine='bash', count_lines}
  ~/src/discount/discount-app/src/main/db/create-tables.sql
  ~/src/discount/discount-app/src/main/db/create_procedure_packages.sql
```

### Run ###
in Windows
```{r, engine='bash', count_lines}
c:\\Oracle\user_projects\domains\base_domain\startWebLogic.exe
```

or in Linux
```{r, engine='bash', count_lines}
/c/Oracle/user_projects/domains/base_domain/startWebLogic.sh
```

### Usage ###
Open URL in your browser:
```{r, engine='bash', count_lines}
 http://localhost:7001/
```

Or open for GWT app (build profile - total-gwt):
```{r, engine='bash', count_lines}
 http://localhost:7001/gwt
```

Or open for JSF app (build profile - total-prime):
```{r, engine='bash', count_lines}
 http://localhost:7001/app
```

### Contribution guidelines ###

* Count files
```{r, engine='bash', count_lines}
find . -type f \( -name "*.java" -o -name "*.sql" \) |wc -l
```
* Count lines
```{r, engine='bash', count_lines}
total_count=0; \
for file in $(find . -type f \( -name "*.java" -o -name "*.sql" \) -print); \
do count=$(cat $file |wc -l);let total_count+=count;done;echo $total_count
```
### Who do I talk to? ###


* Repo admin:  
    - Кяргинский Виктор Борисович <KyarginskiyVB@rbtechnologies.ru>  
    - Крюков Михаил Вячеславович <KryukovMV@rbtechnologies.ru>  

* Repo maintainer:
    - Сотников Алексей Владимирович <SotnikovAV@rbtechnologies.ru>
    - Крюков Михаил Вячеславович <KryukovMV@rbtechnologies.ru>

* Other team contact:
    - Кичигин Андрей Александрович <KichiginAA@rbtechnologies.ru>


