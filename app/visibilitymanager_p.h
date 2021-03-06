#ifndef VISIBILITYMANAGERPRIVATE_H
#define VISIBILITYMANAGERPRIVATE_H

#include "../liblattedock/dock.h"
#include "windowinfowrap.h"
#include "abstractwindowinterface.h"

#include <unordered_map>
#include <memory>

#include <QObject>
#include <QTimer>
#include <QEvent>

#include <plasmaquick/containmentview.h>

namespace Latte {

class VisibilityManager;

/*!
 * \brief The Latte::VisibilityManagerPrivate is a class d-pointer
 */
class VisibilityManagerPrivate : public QObject {
    Q_GADGET
    
public:
    VisibilityManagerPrivate(PlasmaQuick::ContainmentView *view, VisibilityManager *q);
    ~VisibilityManagerPrivate();
    
    void setMode(Dock::Visibility mode);
    void setIsHidden(bool isHidden);
    void setBlockHiding(bool blockHiding);
    void setTimerShow(int msec);
    void setTimerHide(int msec);
    
    void raiseDock(bool raise);
    void updateHiddenState();
    
    void setDockRect(const QRect &rect);
    
    void windowAdded(WId id);
    void dodgeActive(WId id);
    void dodgeMaximized(WId id);
    void dodgeWindows(WId id);
    void checkAllWindows();
    
    bool intersects(const WindowInfoWrap &winfo);
    
    void saveConfig();
    void restoreConfig();
    
    bool event(QEvent *ev) override;
    
    VisibilityManager *q;
    PlasmaQuick::ContainmentView *view;
    std::unique_ptr<AbstractWindowInterface> wm;
    Dock::Visibility mode{Dock::None};
    std::array<QMetaObject::Connection, 4> connections;
    std::unordered_map<WId, WindowInfoWrap> windows;
    QTimer timerShow;
    QTimer timerHide;
    QTimer timerCheckWindows;
    QRect dockRect;
    bool isHidden{false};
    bool dragEnter{false};
    bool blockHiding{false};
    bool containsMouse{false};
};

}

#endif // VISIBILITYMANAGERPRIVATE_H
