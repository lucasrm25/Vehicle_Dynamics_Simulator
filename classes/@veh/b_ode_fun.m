function expr = b_ode_fun(t,in2,in3,in4,in5)
%B_ODE_FUN
%    EXPR = B_ODE_FUN(T,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 8.2.
%    04-Nov-2018 18:33:04

De_pos_xt = in2(16,:);
De_pos_yt = in2(17,:);
De_pos_zt = in2(18,:);
De_ang_phit = in2(13,:);
De_ang_psit = in2(15,:);
De_ang_tetat = in2(14,:);
Dv_fl_bSRt = in2(23,:);
Dv_fr_bSRt = in2(24,:);
Dv_fl_LAUR_3t = in2(19,:);
Dv_fr_LAUR_3t = in2(20,:);
Dv_rl_LAUR_3t = in2(21,:);
Dv_rr_LAUR_3t = in2(22,:);
e_ang_phi = in2(1,:);
e_ang_psi = in2(3,:);
e_ang_teta = in2(2,:);
param3761 = in3(1,:);
param3762 = in3(2,:);
param3763 = in3(3,:);
param3764 = in3(4,:);
param3765 = in3(5,:);
param3766 = in3(6,:);
param3767 = in3(7,:);
param3768 = in3(8,:);
param3769 = in3(9,:);
param3770 = in3(10,:);
param3771 = in3(11,:);
param3772 = in3(12,:);
param3773 = in3(13,:);
param3774 = in3(14,:);
param3775 = in3(15,:);
param3776 = in3(16,:);
param3777 = in3(17,:);
param3778 = in3(18,:);
param3779 = in3(19,:);
param3780 = in3(20,:);
param3781 = in3(21,:);
param3782 = in3(22,:);
param3783 = in3(23,:);
param3784 = in3(24,:);
param3785 = in3(25,:);
param3786 = in3(26,:);
param3787 = in3(27,:);
param3788 = in3(28,:);
param3789 = in4(1);
param3790 = in4(29);
param3791 = in4(57);
param3792 = in4(85);
param3793 = in4(113);
param3794 = in4(141);
param3795 = in4(169);
param3796 = in4(197);
param3797 = in4(225);
param3798 = in4(253);
param3799 = in4(281);
param3800 = in4(309);
param3801 = in4(2);
param3802 = in4(30);
param3803 = in4(58);
param3804 = in4(86);
param3805 = in4(114);
param3806 = in4(142);
param3807 = in4(170);
param3808 = in4(198);
param3809 = in4(226);
param3810 = in4(254);
param3811 = in4(282);
param3812 = in4(310);
param3813 = in4(3);
param3814 = in4(31);
param3815 = in4(59);
param3816 = in4(87);
param3817 = in4(115);
param3818 = in4(143);
param3819 = in4(171);
param3820 = in4(199);
param3821 = in4(227);
param3822 = in4(255);
param3823 = in4(283);
param3824 = in4(311);
param3825 = in4(4);
param3826 = in4(32);
param3827 = in4(60);
param3828 = in4(88);
param3829 = in4(116);
param3830 = in4(144);
param3831 = in4(172);
param3832 = in4(200);
param3833 = in4(228);
param3834 = in4(256);
param3835 = in4(284);
param3836 = in4(312);
param3837 = in4(5);
param3838 = in4(33);
param3839 = in4(61);
param3840 = in4(89);
param3841 = in4(117);
param3842 = in4(145);
param3843 = in4(173);
param3844 = in4(201);
param3845 = in4(229);
param3846 = in4(257);
param3847 = in4(285);
param3848 = in4(313);
param3849 = in4(6);
param3850 = in4(34);
param3851 = in4(62);
param3852 = in4(90);
param3853 = in4(118);
param3854 = in4(146);
param3855 = in4(174);
param3856 = in4(202);
param3857 = in4(230);
param3858 = in4(258);
param3859 = in4(286);
param3860 = in4(314);
param3861 = in4(7);
param3862 = in4(35);
param3863 = in4(63);
param3864 = in4(91);
param3865 = in4(119);
param3866 = in4(147);
param3867 = in4(175);
param3868 = in4(203);
param3869 = in4(231);
param3870 = in4(259);
param3871 = in4(287);
param3872 = in4(315);
param3873 = in4(8);
param3874 = in4(36);
param3875 = in4(64);
param3876 = in4(92);
param3877 = in4(120);
param3878 = in4(148);
param3879 = in4(176);
param3880 = in4(204);
param3881 = in4(232);
param3882 = in4(260);
param3883 = in4(288);
param3884 = in4(316);
param3885 = in4(9);
param3886 = in4(37);
param3887 = in4(65);
param3888 = in4(93);
param3889 = in4(121);
param3890 = in4(149);
param3891 = in4(177);
param3892 = in4(205);
param3893 = in4(233);
param3894 = in4(261);
param3895 = in4(289);
param3896 = in4(317);
param3897 = in4(10);
param3898 = in4(38);
param3899 = in4(66);
param3900 = in4(94);
param3901 = in4(122);
param3902 = in4(150);
param3903 = in4(178);
param3904 = in4(206);
param3905 = in4(234);
param3906 = in4(262);
param3907 = in4(290);
param3908 = in4(318);
param3909 = in4(11);
param3910 = in4(39);
param3911 = in4(67);
param3912 = in4(95);
param3913 = in4(123);
param3914 = in4(151);
param3915 = in4(179);
param3916 = in4(207);
param3917 = in4(235);
param3918 = in4(263);
param3919 = in4(291);
param3920 = in4(319);
param3921 = in4(12);
param3922 = in4(40);
param3923 = in4(68);
param3924 = in4(96);
param3925 = in4(124);
param3926 = in4(152);
param3927 = in4(180);
param3928 = in4(208);
param3929 = in4(236);
param3930 = in4(264);
param3931 = in4(292);
param3932 = in4(320);
param3933 = in4(13);
param3934 = in4(41);
param3935 = in4(69);
param3936 = in4(97);
param3937 = in4(125);
param3938 = in4(153);
param3939 = in4(181);
param3940 = in4(209);
param3941 = in4(237);
param3942 = in4(265);
param3943 = in4(293);
param3944 = in4(321);
param3945 = in4(14);
param3946 = in4(42);
param3947 = in4(70);
param3948 = in4(98);
param3949 = in4(126);
param3950 = in4(154);
param3951 = in4(182);
param3952 = in4(210);
param3953 = in4(238);
param3954 = in4(266);
param3955 = in4(294);
param3956 = in4(322);
param3957 = in4(15);
param3958 = in4(43);
param3959 = in4(71);
param3960 = in4(99);
param3961 = in4(127);
param3962 = in4(155);
param3963 = in4(183);
param3964 = in4(211);
param3965 = in4(239);
param3966 = in4(267);
param3967 = in4(295);
param3968 = in4(323);
param3969 = in4(16);
param3970 = in4(44);
param3971 = in4(72);
param3972 = in4(100);
param3973 = in4(128);
param3974 = in4(156);
param3975 = in4(184);
param3976 = in4(212);
param3977 = in4(240);
param3978 = in4(268);
param3979 = in4(296);
param3980 = in4(324);
param3981 = in4(17);
param3982 = in4(45);
param3983 = in4(73);
param3984 = in4(101);
param3985 = in4(129);
param3986 = in4(157);
param3987 = in4(185);
param3988 = in4(213);
param3989 = in4(241);
param3990 = in4(269);
param3991 = in4(297);
param3992 = in4(325);
param3993 = in4(18);
param3994 = in4(46);
param3995 = in4(74);
param3996 = in4(102);
param3997 = in4(130);
param3998 = in4(158);
param3999 = in4(186);
param4000 = in4(214);
param4001 = in4(242);
param4002 = in4(270);
param4003 = in4(298);
param4004 = in4(326);
param4005 = in4(19);
param4006 = in4(47);
param4007 = in4(75);
param4008 = in4(103);
param4009 = in4(131);
param4010 = in4(159);
param4011 = in4(187);
param4012 = in4(215);
param4013 = in4(243);
param4014 = in4(271);
param4015 = in4(299);
param4016 = in4(327);
param4017 = in4(20);
param4018 = in4(48);
param4019 = in4(76);
param4020 = in4(104);
param4021 = in4(132);
param4022 = in4(160);
param4023 = in4(188);
param4024 = in4(216);
param4025 = in4(244);
param4026 = in4(272);
param4027 = in4(300);
param4028 = in4(328);
param4029 = in4(21);
param4030 = in4(49);
param4031 = in4(77);
param4032 = in4(105);
param4033 = in4(133);
param4034 = in4(161);
param4035 = in4(189);
param4036 = in4(217);
param4037 = in4(245);
param4038 = in4(273);
param4039 = in4(301);
param4040 = in4(329);
param4041 = in4(22);
param4042 = in4(50);
param4043 = in4(78);
param4044 = in4(106);
param4045 = in4(134);
param4046 = in4(162);
param4047 = in4(190);
param4048 = in4(218);
param4049 = in4(246);
param4050 = in4(274);
param4051 = in4(302);
param4052 = in4(330);
param4053 = in4(23);
param4054 = in4(51);
param4055 = in4(79);
param4056 = in4(107);
param4057 = in4(135);
param4058 = in4(163);
param4059 = in4(191);
param4060 = in4(219);
param4061 = in4(247);
param4062 = in4(275);
param4063 = in4(303);
param4064 = in4(331);
param4065 = in4(24);
param4066 = in4(52);
param4067 = in4(80);
param4068 = in4(108);
param4069 = in4(136);
param4070 = in4(164);
param4071 = in4(192);
param4072 = in4(220);
param4073 = in4(248);
param4074 = in4(276);
param4075 = in4(304);
param4076 = in4(332);
param4077 = in4(25);
param4078 = in4(53);
param4079 = in4(81);
param4080 = in4(109);
param4081 = in4(137);
param4082 = in4(165);
param4083 = in4(193);
param4084 = in4(221);
param4085 = in4(249);
param4086 = in4(277);
param4087 = in4(305);
param4088 = in4(333);
param4089 = in4(26);
param4090 = in4(54);
param4091 = in4(82);
param4092 = in4(110);
param4093 = in4(138);
param4094 = in4(166);
param4095 = in4(194);
param4096 = in4(222);
param4097 = in4(250);
param4098 = in4(278);
param4099 = in4(306);
param4100 = in4(334);
param4101 = in4(27);
param4102 = in4(55);
param4103 = in4(83);
param4104 = in4(111);
param4105 = in4(139);
param4106 = in4(167);
param4107 = in4(195);
param4108 = in4(223);
param4109 = in4(251);
param4110 = in4(279);
param4111 = in4(307);
param4112 = in4(335);
param4113 = in4(28);
param4114 = in4(56);
param4115 = in4(84);
param4116 = in4(112);
param4117 = in4(140);
param4118 = in4(168);
param4119 = in4(196);
param4120 = in4(224);
param4121 = in4(252);
param4122 = in4(280);
param4123 = in4(308);
param4124 = in4(336);
param4125 = in5(1,:);
param4126 = in5(2,:);
param4127 = in5(3,:);
param4128 = in5(4,:);
param4129 = in5(5,:);
param4130 = in5(6,:);
param4131 = in5(7,:);
param4132 = in5(8,:);
param4133 = in5(9,:);
param4134 = in5(10,:);
param4135 = in5(11,:);
param4136 = in5(12,:);