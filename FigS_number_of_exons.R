#Plot histogram for number of exons across genes
plotN<-  ggplot(df_noInt2) +
  geom_histogram(aes(blockCount),binwidth = 1,color="#81A88D",fill="#81A88D",size=1.5)  + 
  scale_x_continuous(name='Number of exon')+
  scale_y_continuous(name='Count')+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5,size = 7,face = "bold"),
        strip.background = element_rect(colour="black",fill="aliceblue"),
        strip.text.x = element_text(size =9),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(colour = "black"),#element_rect(fill = NULL),
        legend.position = c(0.88, 0.38),
        legend.key.size = unit(0.3, 'cm'),# axis.text.x = element_blank()
         )

plotN

plot1<-  ggplot(df_noInt2) +
  geom_histogram(aes(blockCount),binwidth = 1,color='#FD6467',fill="#FD6467",size=1.5)  + 
  scale_x_continuous(name='Number of exon')+ #,trans = "log10"
  scale_y_continuous(name='Count')+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5,size = 7,face = "bold"),
        strip.background = element_rect(colour="black",fill="aliceblue"),
        strip.text.x = element_text(size =9),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(colour = "black"),#element_rect(fill = NULL),
        legend.position = c(0.88, 0.38),
        legend.key.size = unit(0.3, 'cm'),# axis.text.x = element_blank()
         )
plot1
#Combine two plots
plot_NZ<-gridExtra::grid.arrange(plotN, plot1, ncol = 2, heights = c(10, 1))
plot_NZ
ggsave(filename = 'N_Z_Number_of_exon.png', plot_NZ,dpi=300,width =5,height = 4)
