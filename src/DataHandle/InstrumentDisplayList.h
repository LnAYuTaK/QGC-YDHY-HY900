#ifndef INSTRUMENTDISPLAYLIST_H
#define INSTRUMENTDISPLAYLIST_H

#include <QObject>
//�Ҳ��Ǳ���ʾ���ݹ�����ʾ
class InstrumentDisplayList : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit InstrumentDisplayList(QObject *parent = nullptr);



signals:

//    2.�Ǳ��������Ͻǣ������ǣ�0.0�㣩����ת�ǡ�ƫ���ǡ��豸״̬������������
//    ����ģʽ�����ߡ����㡢�Զ�������������������ã���



    //���Ƕ�λ��fix 10��float 20����



//    ��ص�ѹ��0.0V�����߶ȣ�0.0m����ˮƽ�ٶȣ�0.0m/s���������ٶȣ�0.0m/s����
//    ����ʱ�䣨0.0min�����������루0.0m����


    //��·�źţ�0%��������¶�1-6��0�� 1�棩������¶�1-6��


private:

   QList<QObject*> _objectList;


};

#endif // INSTRUMENTDISPLAYLIST_H
