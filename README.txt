# general

в репе есть две ветки:
- master
- without_vagrant


первая это если мы ставимся на вагрант
вторая это если мы ставимся на любые машины которые происаны в inventory неважно вагрант не вагрант



# kubespray_vagrant
deploy k8 via kubespray on vagrant

documentation - https://github.com/aceqbaceq/docs/blob/master/kubespray.txt


изначально инсталляция работала через start.yml который использовал pip но поскольку они там чтото сломали в pip
то пришлось перейти на poetry (что практически такой же хрен как предыдущая редька но чуть лучше), поэтому start.yml
остался просто для исторической справки.

для установки кубернетеса через kubesparay запускаем start.bash

openebs.yml его я ставил на готовый куб уже потом отдельно.

