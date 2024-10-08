setwd('./annotation')
{library(tidyverse)
library(ggrepel)
library(ggplot2)
library(wesanderson)
library(gridExtra)
#library(plyr)
library(dplyr)
library(stringr)
}
#####################################
# p1 and p2
#####################################

## files required for matching
# ?
setwd('./annotation')

MyOrder<-c('1','1A','2','3','4','4A','5','6','7','8','9','10','11','12','13','14','15','17','18','19','20','21','22','23','24','25','26','27')
MyOrder<-as.character(MyOrder)
chrs = read.table("./Zcap\\circos/CHR_coords_1.bed", colClasses = c("character", "numeric", "numeric", "character"), sep = "\t")
names(chrs) <- c('scaffold','start','end','chr')
chrs<-chrs[order(match(chrs$chr,MyOrder)),]
#Chr name manipulate
KeyMatch<-read.table('./Zcap\\circos/Compare_chr_list.sort',header=F,col.names=c('chr','Chromosome'))
KeyMatch<-KeyMatch[order(match(KeyMatch$Chromosome,MyOrder)),]

names(chrs)<-c('scaffold','start','end','chr')
chrs<-chrs%>%
  filter(chr!='W')
KeyMatch<-KeyMatch%>%
  filter(Chromosome!='W')

# Read in GC file
#GC <- read.table("M:/ROSLIN/WCS/WCS_Genome/circos_plot/GC_CONTENT_200k_bedtools_nuc.bed")#
#Bash: compute GC
#cd /exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/WCS/Genome_WCS/Fasta
# seqkit fx2tab -n -g GWCS.softmasked.fasta.fsa>GWCS.softmasked.fasta.fsa.seqkittab

GC <- read_tsv("ZCAP.softmasked.fasta.seqkittab",col_names = c('chr','GC'),col_types = cols(
 chr = "f",GC='n'))
GC$start= 0
GC$end<- str_split(GC$chr,'_',simplify = T)[,3]
GC<-GC[,c("chr", "start", "end", "GC")]
GC <- plyr::join(GC,KeyMatch,by="chr",type='left') 
head(GC)
GC$chr<-GC$Chromosome
GC <- GC[,1:4]

#only keep the ones with chromosome assign
GC<-GC%>%
  drop_na()

detach(package:plyr)
GC_sum=GC
GC_sum$end<-as.numeric(as.character(GC_sum$end))
GC_sum$chr<-as.factor(as.character(GC_sum$chr))

#GC contents By size
sizeorder=chrs[order(chrs$end,decreasing = T),]
#Test correlation P vsl
cor(GC_sum$end, GC_sum$GC, method =  "spearman")#spearman rank
cor.test(GC_sum$end, GC_sum$GC, method =  "spearman")

p1<-ggplot(GC_sum,aes(x=log(end), y= GC,color = factor(chr,level=MyOrder),label = factor(chr)))+
  xlab('Chr length (log)')+
  ylab('GC content %')+
  annotate("text", x = 16.5, y = 38, label ="P=3.795x10^-8\nrho=-0.99",color='black')+
  scale_color_manual(values=wes_palette("GrandBudapest1", 35, type = "continuous"))+
  annotate("text", x = 18, y =50.5, label ="Z. Capensis",color='black',size=5,fontface =3)+
  scale_y_continuous(expand = c(0,1))+
  geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf,size=5) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p1

####################Read in reapeat file

# repeat
repeat_density_p <- read.table("./Zcap\\circos/REPEATS_200k.bed",sep=" ",col.names = c("chr", "start", "end", "ovl"))#REPEATS_200k.bed

head(repeat_density_p)
######
repeat_density_p$chr<-as.factor(repeat_density_p$chr)

repeat_sum<-
  repeat_density_p%>%
  group_by(chr)%>%
  summarise(Repeats=sum(ovl)) %>%
  mutate(start=0,
         end=as.numeric(str_split(chr,'_',simplify = T)[,3]),
         Rep= (100*Repeats/end),
  ) %>%
  select(chr,start,end,Rep) %>%
  left_join(KeyMatch,by="chr")%>%
  drop_na()%>%
  select(Chromosome,start,end,Rep) 

  colnames(repeat_sum)=c("chr", "start", "end", "Rep")

#GC contents By size
sizeorder=chrs[order(chrs$end,decreasing = T),]

#Or x axis use length  
#Test correlation P vsl
cor(repeat_sum$end, repeat_sum$Rep, method =  "spearman")#spearman rank
cor.test(repeat_sum$end, repeat_sum$Rep, method =  "spearman")
library(ggrepel)

p2<-ggplot(repeat_sum,aes(x=log(end), y=Rep,color = factor(chr,level=MyOrder),label = chr))+
  xlab('Chr length (log)')+
  ylab('Repeat content %')+
  annotate("text", x = 15.85, y = 6, label = "P=0.0067\nrho=-0.51",color='black')+
  scale_color_manual(values=wes_palette("GrandBudapest1", 35, type = "continuous"))+
  annotate("text", x = 18, y =25, label ="Z. Capensis",color='black',size=5,fontface =3)+
  scale_y_continuous(expand = c(0,1))+
  geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf,size=5) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))


p2

#####################################
# p4
#####################################
setwd('./Zcap/annotation')
library(tidyverse)
df1<-read_tsv(
  'augustus.hints.gff3', 
  col_names = c(
    "chrom" ,
    "source" ,
    "type" ,
    "start",
    "end",
    "score",
    "strand",
    "phase",
    "attributes"),
  col_types = cols(
    chrom = "c",
    source="c",
    type="c",
    start = "i",
    end = "i",
    score = 'c',
    strand = 'c',
    phase='c',
    attributes = 'c'))
head(df1)

unique(df1$type)

print((table(df1$type)))
stat1<- df1%>%
  filter(type=='gene') %>%
  group_by(chrom) %>%
  summarize( N_gene = n()) %>%
  arrange(desc(N_gene))
head(stat1)

library(dplyr)
library(stringr)
library(ggrepel)
library(ggplot2)
library(wesanderson)

stat1$chr_num <-str_split(stat1$chrom,'_',simplify = T)[,2]

fai <- read.table('ZCAP.softmasked.fasta.fai',header=F)
fai$chr_num <-str_split(fai$V1,'_',simplify = T)[,2]
names(fai)<-c('chrom','chr_size','V3','V4','V5','chr_num')
fai<-fai %>% select('chrom','chr_size','chr_num')
stat1<- stat1 %>% left_join(fai,by=c('chrom','chr_num'))

stat1$chr_size<-as.integer(stat1$chr_size)
#gene contents By size
sizeorder=stat1[order(stat1$chr_size,decreasing = T),]
KeyMatch<-read.table('./Compare_chr_list.sort',header=F,col.names=c('chr','Chromosome'))
KeyMatch<-KeyMatch[order(match(KeyMatch$Chromosome,MyOrder)),]

names(KeyMatch)<-c('chrom','Chromosome')
stat0<-stat1
stat1<-plyr::join(stat1,KeyMatch,by="chrom",type='right')
#Plot and  p val
#Test correlation P vsl
cor(stat0$chr_size, stat0$N_gene, method =  "spearman")#spearman rank
cor.test(stat0$chr_size, stat0$N_gene, method =  "spearman", exact = FALSE)

stat1$Chromosome<-as.factor(as.character(stat1$Chromosome))
stat1$chrom<-as.factor(as.character(stat1$chrom))
stat1$N_gene<-as.numeric(stat1$N_gene)

##########Gene density
library(RIdeogram)

tets_karyotype_0<-stat1[,c('Chromosome','chr_size')]
tets_karyotype_0$Start<-0
tets_karyotype_0<-tets_karyotype_0[,c('Chromosome','Start','chr_size')]
names(tets_karyotype_0)<-c('Chr','Start','End')
test_karyotype<-tets_karyotype_0
#write_tsv(test_karyotype,'test_karyotype_major.txt',col_names = T)

#Prepare Gff major file, select only 30 scaffolds
# majorScaffold<-stat1[,1,drop=F]
# write_tsv(majorScaffold,'Zcap_matching_scaffold_nm.txt.major',col_names = F)
# # bash: grep -f Gambels_matching_scaffold_nm.txt.major evm_GWCS_13.EVM.gff3 > evm_GWCS_13.EVM.gff3.major.gff3
# #grep -f Zcap_matching_scaffold_nm.txt.major augustus.hints.gff3 > augustus.hints.gff3.major.gff3

# write_tsv(df2_m,'augustus.hints.gff3.major_rnm.gff3',col_names = FALSE)
gene_density <- GFFex(input = "augustus.hints.gff3.major_rnm.gff3", karyotype = 'test_karyotype_major.txt', feature = "gene", window = 100000)
test_karyotype$Chr<-as.character(test_karyotype$Chr)
ideogram(karyotype = test_karyotype, overlaid = gene_density) #,colorset1 = c("#f7f7f7", "#e34a33")
convertSVG("chromosome.svg", device = "png")

#detach(package:plyr)
head(gene_density)
gene_density<-tibble(gene_density)

GD<- gene_density %>%
  #mutate(Dense= Value/100000) %>%
  group_by(Chr) %>%
  summarize(Gene_total= sum(Value),
            Gene_dens=mean(Value),
            size=max(End))%>%
  arrange(as.factor(as.character(Chr)))%>%
  write_tsv("Gene_density_by_chr.txt")

#Plot and  p val
#Test correlation P vsl
names(GD)<-c('Chromosome', "Gene_total", "Gene_dens" , "Size" )
GD1<-plyr::join(GD,stat1,by="Chromosome",type='left')
GD1<-as.data.frame(GD1)
cor(GD1$Size, GD1$Gene_dens, method =  "spearman")#spearman rank
cor.test(GD1$Size, GD1$Gene_dens, method =  "spearman", exact = FALSE)
library(ggrepel)
library(ggplot2)
library(wesanderson)
# 
p4<-ggplot(GD1,aes(x=log(Size), y=Gene_dens,color = factor(Chromosome,level=MyOrder),label = Chromosome ))+ #,label = chrom
  xlab('Chr length (log)')+
  ylab('Gene density (100Kb window)')+
  #labs(title = "Chr gene number",)+
  annotate("text", x = 16.2, y = 1, label = "P< 2.2x10^-16\nrho=-0.97",color='black')+
  scale_color_manual(values=wes_palette("GrandBudapest1", 35, type = "continuous"))+
  annotate("text", x = 18, y =4, label ="Z. Capensis",color='black',size=5,fontface =3)+
  scale_y_continuous(expand = c(0,0.1))+
   geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf,size=5) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p4

p_c<-gridExtra::grid.arrange(p1,p2,p4, ncol=3)

ggsave('Chr_GC_repeat_gene_density_bysize.png',p_c,width = 10,height =5,unit='in',dpi = 350)
#END#
